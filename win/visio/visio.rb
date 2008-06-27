require 'win32ole'

module Visio
    def connect
        visio = nil
        begin
            visio = WIN32OLE.connect('Visio.Application')
        rescue
            visio = WIN32OLE.new('Visio.Application')
        end
        if (Visio::constants.size == 0)
            WIN32OLE.const_load(visio, Visio)
        end
        visio
    end

    def open_document(visio, file)
        file = normalize_file_name(file)
        doc = get_document_item(visio.documents, file)
        doc ? doc : visio.documents.open(file)
    end

    def close_all_documents(visio)
        visio.documents.each {|doc|
            visio.alertResponse = 7
            doc.close
        }
    end

    def normalize_file_name(file)
        File.expand_path(file).gsub('/', '\\')
    end

    def drop_master_on_page(page, master_name, stencil_name, pin_x, pin_y)
        stencil = get_stencil(page.application.documents, stencil_name)
        master = get_master_item(stencil, master_name)
        page.drop(master, pin_x, pin_y)
    end

    def get_stencil(documents, name)
        stencil = get_document_item(documents, name)
        if !stencil
            begin
                stencil = documents.openEx(name, VisOpenRO + VisOpenDocked)
            rescue
                name = (File.dirname(__FILE__) + '/' + name).gsub('/', '\\')
                stencil = documents.openEx(name, VisOpenRO + VisOpenDocked)
            end
        end
        stencil
    end

    def get_document_item(documents, name)
        documents.each {|doc|
            return doc if doc.name == name
        }
    end

    def get_master_item(stencil, name)
        stencil.masters.itemU(name)
    end

    def dump(shape, indent = '')
        collector = "#{indent}shape text:#{shape.text} name:#{shape.name}, master:#{shape.master ? shape.master.name : 'no master'}\n"
        shape.shapes.each {|child|
            collector << dump(child, indent + '   ')
        }
        collector
    end
end

# for convenience in case you don't want to include visio yourself
class VisioClass
    include Visio
end
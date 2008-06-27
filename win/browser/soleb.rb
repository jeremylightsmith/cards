require 'vr/vrcontrol'
require 'vr/vrlayout2'
require 'win32ole'

class OLEINFO
  @members = []
  def typelibs
    WIN32OLE_TYPE.typelibs.select{|t|
      t.size > 0
    }.sort
  end

  def ole_classes(tlib)
    begin
        WIN32OLE_TYPE.ole_classes(tlib).collect {|t|
          t.name
        }.sort
    rescue
        puts 'error loading type library/dll'
    end
  end

  def ole_members(tlib, klass)
    @members = []
    k = WIN32OLE_TYPE.ole_classes(tlib).find {|t|
      t.name == klass
    }
    return [] if !k
    @members = (k.ole_methods + k.variables).sort{|m1, m2|
      m1.name <=> m2.name
    }
    (@members).collect {|m|
      m.name
    }
  end

  def ole_class_info(tlib, klass)
    k = WIN32OLE_TYPE.ole_classes(tlib).find {|t|
      t.name == klass
    }
    return "" if !k
    "#{k.ole_type}  #{k.name}\r\n" +
    "  GUID : #{k.guid}\r\n" +
    "  PROGID : #{k.progid}\r\n" +
    "  DESCRIPTION : #{k.helpstring}\r\n\r\n"
  end

  def method_info(m)
    info = ""
    info += "Event " if m.event?
    info += m.invoke_kind 
    info += " "
    info += m.return_type
    info += " "
    info += m.name
    info += "\r\n"
    info += "  Dispatch ID : #{m.dispid}\r\n"
    info += "  DESCRIPTION : #{m.helpstring}\r\n" 
    m.params.each_with_index do |param, i|
      pinfos = []
      pinfos.push "IN" if param.input?
      pinfos.push "OUT" if param.output?
      pinfos.push "OPTION" if param.optional?
      pinfo = "arg#{i+1} - #{param.ole_type} #{param.name} [#{pinfos.join(',')}]"
      pinfo += " = #{param.default}" if param.default
      info += "  #{pinfo}\r\n"
    end
    info += "\r\n"
    info += "  Event Interface : #{m.event_interface}\r\n" if m.event?
    info
  end

  def variable_info(m)
    info = "\r\n  #{m.variable_kind} #{m.ole_type} #{m.name}"
    info += " = #{m.value}" if m.value
    info
  end

  def ole_member_info(tlib, klass, member, i)  
    k = WIN32OLE_TYPE.ole_classes(tlib).find {|t|
      t.name == klass
    }
    return "" if !k
    m = (k.ole_methods + k.variables).find {|mm|
       mm.name == member
    }
    m = @members[i]
    return "" if !m
    if m.kind_of?(WIN32OLE_METHOD)
      return method_info(m)
    else
      return variable_info(m)
    end
  end
end

class MyForm2 < VRForm
  include VRResizeable
  VERSION = '0.0.1a'
  def construct
    self.caption = "Simple OLE Browser #{VERSION}"
    @oleinfo = OLEINFO.new

    addControl VRListbox, "lst_class","",0,0,10,10
    addControl VRListbox, "lst_member","",10,0,10,10
    @k1=VRHorizTwoPaneFrame.new(@lst_class,@lst_member).setup(self)

    addControl VRListbox, "lst_tlib","",0,0,10,10
    @lst_tlib.setListStrings @oleinfo.typelibs
    @k2=VRVertTwoPaneFrame.new(@lst_tlib,@k1).setup(self)

#    addControl VRStatic, "info", "", 0,0,10,10
    addControl VRText, "info", "", WStyle::WS_HSCROLL
    @k3 = VRVertTwoPaneFrame.new(@k2,@info).setup(self)

    select_by_name(@lst_tlib, 'Microsoft Visio 11.0 Type Library')
  end

  def select_by_name(list, name)
#    for i in 0..list.getCount() - 1
#      if list.getTextOf(i) == name
#        list.select(i)
#      end
#    end
    puts list.methods.sort
  end

  def self_resize(w,h)
    @k3.move 5,5,w-10,h-10
  end

  def lst_tlib_selchanged
    @lst_class.setListStrings @oleinfo.ole_classes(@lst_tlib.getTextOf(@lst_tlib.selectedIndex))
  end

  def lst_class_selchanged
    @lst_member.setListStrings @oleinfo.ole_members(
      @lst_tlib.getTextOf(@lst_tlib.selectedIndex),
      @lst_class.getTextOf(@lst_class.selectedIndex))
    @info.caption = @oleinfo.ole_class_info(
      @lst_tlib.getTextOf(@lst_tlib.selectedIndex),
      @lst_class.getTextOf(@lst_class.selectedIndex))
  end

  def lst_member_selchanged
    @info.caption = 
    @oleinfo.ole_class_info(
      @lst_tlib.getTextOf(@lst_tlib.selectedIndex),
      @lst_class.getTextOf(@lst_class.selectedIndex)) + 
    @oleinfo.ole_member_info( 
      @lst_tlib.getTextOf(@lst_tlib.selectedIndex),
      @lst_class.getTextOf(@lst_class.selectedIndex),
      @lst_member.getTextOf(@lst_member.selectedIndex),
      @lst_member.selectedIndex)
  end
end

VRLocalScreen.start MyForm2

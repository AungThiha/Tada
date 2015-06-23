=begin
This file is part of Tada
Copyright (C) 2015-2016 Aung Thiha

Based on Rabbit from Ko Htain Linn Shwe and MyanmarZawgyiConverter.java from Unicode CLDR ( Common Locale Data Repository )

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
=end

#checking OS
host_os = RbConfig::CONFIG['host_os']
if host_os == /mswin|msys|mingw|cygwin|bccwin|wince|emc/ # this is windows
  @seperator = "\\"
else # os x or linux
  @seperator = "/"
end

#import ZawgyiUniRule.rb
require ".#{@seperator}assets#{@seperator}ZawgyiUniRule.rb"

#generating converter
converter_template = 'const-string v3, "%s"

    const-string/jumbo v4, "%s"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    
    '
converter = converter_template % [ 'null', '\uFFFF\uFFFF']
fix_jdk7_bug = converter_template % [ 'null', '']
ZawgyiUniRule.rules.each do |rule|
	convert_statement = converter_template % [ rule[:from], rule[:to]]
	converter << convert_statement
	converter << fix_jdk7_bug
end
fix_jdk7_bug = converter_template % ['\uFFFF\uFFFF', 'null']
converter << fix_jdk7_bug

#read ZawgyiDetectPattern
zawgyi_dector = File.read(".#{@seperator}assets#{@seperator}ZawgyiDetectPattern.txt")

# read Tada.smali template
tada_smali_template = File.read(".#{@seperator}assets#{@seperator}Tada.smali")

# create Tada.smali content
tada_smali_content = tada_smali_template % [zawgyi_dector, converter]

# write Tada.smali content to output Tada.smali file
File.write(".#{@seperator}output#{@seperator}Tada.smali", tada_smali_content)

# tell the user it's done
puts '"Tada.smali" is generated in "output" folder'
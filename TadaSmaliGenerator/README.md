## Tada Smali Generator
This tool is used to generate a Tada.smali which is used as an asset in the installer.


### How to use
1. Run it with the following command
```
ruby generator.rb
```
2. "Tada.smali" will be generated in "output" folder
3. Replace "Tada.smali" in "assets" folder of the installer with the generated one.
4. Now, Tada installer is updated with the newly generated Tada.smali


### How to contribute
* Pattern used to detect Zawgyi is in "assets/ZawgyiDetectPattern". Java comment and new line character are not allowed in this file. Only plain regex is allowed.
* Zawgyi to unicode convertion rule is in "assets/ZawgyiUniRule.rb". It is assigned to a variable named "@rules". It's pretty much like a json array but you cannot insert space between key(such as "from", "to") and colon, values can only be single-quoted while keys can be neither double-quoted nor single-quoted.  


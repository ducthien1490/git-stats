Line code analyzer for RoR project
=========
This program uses to evaluate lines code which are added or removed in RoR prioject
File types: ruby (.rb), javascript (.js), configuraiton file (.yml), test (.spec)

Install
---
- ImageMagick:
  - Ubuntu:
    ```
    sudo apt-get install libmagickwand-dev imagemagick libmagickcore-dev
    && gem install rmagick
    ```
  - OSX:
    ```
    sudo port install ImageMagic
    && gem install rmagic
    ```
- Gruff:
  ```gem install gruff```

Usage
---
- Run ruby script:
  ```ruby line_code_analizer.rb [option]```

- Options:
  ```
  -r [resposibility name]
  -p [directory of resposibility]
  -b [branch name]
  -f [from date YYYY/MM/DD]
  -t [to date YYYY/MM/DD]
  -c [classification of file rb,js,yml,spec]
  -h [show help]
  ```
- Example:
  ```
  ruby line_code_analizer.rb -r myproject -p ~/project/myproject/ -b master -f 2014/11/01 2014/12/31 -c rb,js
  ```
- Output of program: ".png" file contain statistics of file type

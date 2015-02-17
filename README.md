# kincomi
Kindle Paperwhite .mobi generator for Comic/Manga
## Install
```shell
sh setup.sh
```
## Usage
All comics should be placed under ``materials`` directory with the naming convention:
``[AUTHOR]TITLE``

Under the comic directory, lies the pages for individual episodes. Both in the numeric format depending on the original order.

Here's an example directory hierarchy:
```
materials
|- [Puyo]Nagato Yuki-chan no Shoushitsu
  |- 001
    |- 001.jpg
    |- 002.jpg
    ...
    |- 045.jpg
```

Use following command to compile comics into .mobi files:

```shell
bundle exec ruby kincomi.rb
```

Generated .mobi files would be placed under ``generated`` directory.

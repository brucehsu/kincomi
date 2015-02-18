# kincomi
Kindle Paperwhite .mobi generator for Comic/Manga
## Install
```shell
bundle install
```
## Usage
```shell
bundle exec ruby kincomi.rb [8comic ids]
```

kincomi would automatically downloads comics from 8Comic with given ids and convert downloaded comics to .mobi files.

Generated .mobi files are placed under ``generated`` directory.

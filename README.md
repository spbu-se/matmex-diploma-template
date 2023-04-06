## Как это использовать

* Рекомендованный способ: использовать [Overleaf](https://www.overleaf.com/) или [Papeeria](https://papeeria.com/)
  * Загружаете файлы шаблона в проект с сохранением структуры папок
  * Выбираете в качестве компилятора XeTeX (или LuaTeX) (например, в Overleaf это Menu -> Compiler)
* Альтернативный способ: поставить дистрибутив TeX (например, [TeXLive](https://www.tug.org/texlive/))


## Как это собирать

В случае использования локального дистрибутива TeX стандартный способ сборки это использование команды
```sh
make
```
По-умолчанию, она соберет шаблон с помощью XeTeX.
В случае, если хочется использовать LuaLaTeX можно либо исправить переменную `ENGINE` в Makefile, либо вызывать `make` следующим образом:
```sh
make ENGINE=lualatex
```

Кроме того, `make` знает команды `clean` и `dist-clean`.
Первая из них удалит все временные файлы, а вторая в дополнение к этому удалит и сгенерированный pdf файл.
#### TODO

* перевод на русский в списке литературы: online, accessed и т.д.
* сортировка списка литературы (сейчас англоязычные пункты в начале)


##### Тонкости

* A few external packages are required. Use `make depext` to install them (if you use local TeX distribution. No action is needed if you use online editors)
* File `ugost2008ls.bst` was adopted from [here](https://github.com/anlun/Russian-Phd-LaTeX-Dissertation-Template/tree/master/BibTeX-Styles) because original one from APT package `texlive-lang-cyrillic` gives a weird error:

    ```sh
    bibtex "\" can't start a style-file command- ...
    ```

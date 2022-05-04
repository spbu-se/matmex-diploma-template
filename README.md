## Как это использовать

* Рекомендованный способ: использовать [Overleaf](https://www.overleaf.com/) или [Papeeria](https://papeeria.com/)
  * Загружаете файлы шаблона в проект с сохранением структуры папок
  * Выбираете в качестве компилятора XeTeX (например, в Overleaf это Menu -> Compiler)
* Альтернативный способ: поставить дистрибутив TeX (например, [TeXLive](https://www.tug.org/texlive/))

#### TODO

* перевод на русский в списке литературы: online, accessed и т.д.
* сортировка списка литературы (сейчас англоязычные пункты в начале)


##### Тонкости

* A few external packages are required. Use `make depext` to install them (if you use local TeX distribution. No action is needed if you use online editors)
* File `ugost2008ls.bst` was adopted from [here](https://github.com/anlun/Russian-Phd-LaTeX-Dissertation-Template/tree/master/BibTeX-Styles) because original one from APT package `texlive-lang-cyrillic` gives a weird error:

    ```
    bibtex "\" can't start a style-file command- ...
    ```

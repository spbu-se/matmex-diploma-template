%!TEX root = vkr.tex
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{matmex-diploma-custom}[2020/12/09 MatMex LaTeX diploma class]
\def\my@fontsize{12pt}\def\my@baseclass{article}\def\my@title12pt{}\def\my@body14pt{}

% Если используется опция 14pt то нужно несколько хаков
\DeclareOption{14pt}{
    \def\ignore#1{}
    % во-первых, класс наследуется от extarticle
    \def\my@fontsize{14pt}
    \def\my@baseclass{extarticle}

    % во-вторых, титульный лист должен набираться так, как будто
    % используется шрифт 12pt - иначе он выглядит совсем конским
    % Для этого мы явно загружаем size12.clo, но так как он на такое не рассчитан,
    % и использует \newcommand для определения всяких \small и \Large
    % то у нас \newcommand временно превращается в \renewcommand
    \let\orignewcommand\newcommand
    \let\origNeedsTeXFormat\NeedsTeXFormat
    \def\my@title12pt{
        \let\newcommand\renewcommand
        \makeatletter
        \input{size12.clo}%
        \makeatother
        \let\newcommand\orignewcommand
    }
    % в-третьих, после того как титульный лист сгенерирован, нужно снова вернуться
    % к базовому шрифту 14pt. Применяется такой же хак: загрузи size14.clo
    % временно переопределив \newcommand => \renewcommand
    \def\my@body14pt{
        % отдельное внимание подавлению команды \NeedsTeXFormat, которая требует
        % чтобы код size14.clo выполнялся в преамбуле (а тут он уже внутри документа)
        \let\NeedsTeXFormat\ignore
        \let\newcommand\renewcommand
        \makeatletter
        \input{size14.clo}%
        \makeatother
        \let\newcommand\orignewcommand
        \let\NeedsTeXFormat\origNeedsTeXFormat
    }
}
\ProcessOptions\relax
\LoadClass[a4paper,\my@fontsize]{\my@baseclass}

% Поля настраиваются командами \newgeometry во время и после генерации титульных
% страниц и
\usepackage[a4paper]{geometry}

\usepackage{fancyhdr}
\usepackage{ifthen}

%% Мы используем компилятор XeLaTex или LuaLaTeX, который дружит с Unicode и
%% True Type/Open Type шрифтами. Попытка собрать чем-то другим приведет к
%% страшным и непонятным ошибкам, поэтому упадём с понятным сообщением.
\usepackage{iftex}
\ifXeTeX
\else
    \ifLuaTeX
    \else
        %% https://github.com/latex3/iftex/blob/a36f09ed85c47dfd8ab59ae2cc0a8c9fb99c73e1/iftex.sty#L44
        \newlinechar 64\relax
        \errorcontextlines -1\relax
        \immediate\write20{@
            ***********************************************************@
            * XeLaTex or LuaLaTex is required to compile this document.@
            * Sorry!@
            ***********************************************************}%
        \batchmode\read -1 to \@tempa
    \fi
\fi

%% Для русификации достаточно подключить пакет fontspec и
%% выбрать Unicode шрифт в котором есть кириллические глифы. Ниже
%% основным шрифтом выбирается Unicode версия шрифта Computer Modern с заcечками
\usepackage{fontspec}
\setmainfont{CMU Serif}
\setsansfont{CMU Sans Serif}
\setmonofont{CMU Typewriter Text}
%\setmonofont{Fira Code}[Contextuals=Alternate,Scale=0.9]
%\setmonofont{Inconsolata}
% \newfontfamily\cyrillicfont{CMU Serif}

%% В XeLaTex или LuaLaTeX альтернативой известного пакета babel является пакет polyglossia.
%% Теперь у нас будут переносы слов
\usepackage{polyglossia}
\setdefaultlanguage{russian}
\setotherlanguage{english}

% \addto\captionsrussian{%
%   \renewcommand{\figurename}{Рис.}%
%   \renewcommand{\tablename}{Табл.}%
% }

% Основные необходимые пакеты и команды.

%%% Пакеты
%% Графика
\usepackage[table]{xcolor} % Работа с цветами
\usepackage{graphicx} % Вставка графики в текст (изображения, в т.ч. pdf)
\graphicspath{ {figures/} } % Задает папку по-умолчанию для графики

\usepackage{wrapfig2} % Позволяет вставлять графику, обтекаемую текстом
\usepackage{caption} % Настройка подписей "не текста"
\usepackage{subcaption} % Подписи для разделенного "не текста"

%% Математика
\usepackage{amsmath, amsfonts, amssymb, amsthm, mathtools} % "Адекватная" работа с математикой в LaTeX
\usepackage{thmtools} % Мощный пакет для работы с математическими окружениями типа "теорема"
\usepackage{thm-restate} % Дополнение к предыдущему пакету, позволяющее повторять теоремы

%% Таблицы
\usepackage{tabularx} % Добавляет столбец типа "X", который автоматически занимает максимально возможное место
\usepackage{makecell} % Позволяет кастомизировать ячейки таблицы

%% Код
\usepackage{listings} % Позволяет вставлять код в документ
% Перевод заголовков в листингах
\renewcommand\lstlistingname{Листинг}
\renewcommand\lstlistlistingname{Листинги}
% Отступ перед подписью листинга
\DeclareCaptionFormat{listing}{
    \hspace{15pt}#1#2#3
}
\captionsetup[lstlisting]{
    format=listing,
    margin=0pt,
    font={bf}
}
\lstset{
    mathescape=true,
    identifierstyle=\ttfamily,
    keywordstyle=\bfseries,
    commentstyle=\scriptsize\rmfamily,
    basewidth={0.5em,0.5em},
    fontadjust=true,
}

% Требует Python с пакетом pygmentize, зато позволяет верстать очень годные листинги с синтаксической подсветкой
\usepackage[kpsewhich,newfloat]{minted}

% Запретим minted подсвечивать по его мнению лексические ошибки
\AtBeginEnvironment{minted}{\dontdofcolorbox}
\def\dontdofcolorbox{\renewcommand\fcolorbox[4][]{##4}}

\SetupFloatingEnvironment{listing}{name=Листинг}
\SetupFloatingEnvironment{listing}{listname=Листинги}
\captionsetup[listing]{
    format=listing,
    margin=0pt,
    font={bf}
}

%% Текст
\usepackage[inline]{enumitem} % Настройка списков, а так же "строчные" списки
% \setitemize{noitemsep,topsep=0pt,parsep=0pt,partopsep=0pt}
% \setenumerate{noitemsep,topsep=0pt,parsep=0pt,partopsep=0pt}

\usepackage[useregional]{datetime2} % Форматирование дат
\usepackage[normalem]{ulem} % Дополнительные варианты форматирования текста, например подчеркивание или зачеркивание
\usepackage{microtype} % Полезные типографические ништячки, по-хорошему требует LuaLaTeX
\usepackage[autostyle]{csquotes} % Правильные кавычки в зависимости от языка

%% Разное
\usepackage{afterpage} % Выполнение команд после разрыва страниц
\usepackage{pdflscape} % Правильное отображение альбомной страницы в pdf файле

%%% Команды
% Смена \phi и \varphi
% https://tex.stackexchange.com/a/50365/171947
\expandafter\mathchardef\expandafter\varphi\number\expandafter\phi\expandafter\relax
\expandafter\mathchardef\expandafter\phi\number\varphi

%https://tex.stackexchange.com/questions/30720/footnote-without-a-marker
\newcommand\blfootnote[1]{%
    \begingroup
    \renewcommand\thefootnote{}\footnote{#1}%
    \addtocounter{footnote}{-1}%
    \endgroup
}

\fancypagestyle{withCompileDate}{%
    \fancyhf{}
    \fancyfoot[C]{\thepage}
    \fancyfoot[R]{\small Дата сборки: \today}
    \renewcommand{\headrulewidth}{0pt}
}

%% Гиперссылки
\usepackage[colorlinks=true,urlcolor=blue,linkcolor=black,filecolor=black,citecolor=black]{hyperref}

%% Включение графических файлов
%% we don't need to load graphicx since it will be loaded by xunicode (which is loaded by fontspec)
\usepackage[titletoc]{appendix}

%% Эта команда добавляет отчеркнутое место для подписи после имени
%% Аргументы: имя и пояснение под чертой (например, слово "подпись")
\def\sigspace{\\[3em]}
\newcommand\sigplace[2]{
#1\\[1.2em]
\underline{\hspace{3cm}}\\[-0.2em]
{\footnotesize #2}
\def\sigspace{\\[1em]%
    \def\sigspace{\\[3em]}}
}

\input{pretitle.tex}

%% Титульная страница на русском языке
\newcommand\maketitleru{
    \fancypagestyle{titleru}{
        \fancyhf{}  % clear all header and footer fields
        \renewcommand{\headrulewidth}{0pt}  % remove head ruler
        % В верхнем колонтитуле будет университет, кафедра и группа, если это курсовая/практика, или просто университет для ВКР
        \chead{\large
            Санкт-Петербургский государственный университет
            \vskip 1em
            \ifthenelse{\equal{\my@title@type@ru}{bachelor} \OR \equal{\my@title@type@ru}{master}}
            {}
            {
                {\large \my@title@chair@ru }
                \vskip 1em
                    {\large Группа \my@title@group@ru }
            }
        }
        % В нижнем колонтитуле город и год
        \cfoot{\large\parbox[b]{\textwidth}{\centering Санкт-Петербург\\ \my@title@year@ru}}
    }

    \title{\my@title@title@ru}
    \begin{titlepage}
        \newgeometry{top=20mm,bottom=20mm,left=20mm,right=15mm,nohead,includeheadfoot}
        \thispagestyle{titleru}
        \begin{center}

            \vspace*{0.25\textheight}

            \ifthenelse{\equal{\my@title@type@ru}{coursework} \OR \equal{\my@title@type@ru}{practice} \OR \equal{\my@title@type@ru}{production} \OR \equal{\my@title@type@ru}{prediploma}}
            {
            {\Huge \@title}
            \vskip 2em
                {\Large\textbf{\textit{\my@title@author@ru}}}
            \vskip 1em
                {\large
                    \ifthenelse{\equal{\my@title@type@ru}{production}}
                    {Отчёт по производственной практике}
                    {\ifthenelse{\equal{\my@title@type@ru}{coursework}}
                        {Отчёт по курсовой работе}
                        {\ifthenelse{\equal{\my@title@type@ru}{practice}}
                            {Отчёт по учебной практике}
                            {Отчёт по преддипломной практике}
                        }
                    }\\
                    \ifthenelse{\equal{\my@title@kind@ru}{solution}}
                    {в форме \enquote{Решение}}
                    {\ifthenelse{\equal{\my@title@kind@ru}{experiment}}
                        {в форме \enquote{Эксперимент}}
                        {\ifthenelse{\equal{\my@title@kind@ru}{production}}
                            {в форме \enquote{Производственное задание}}
                            {\ifthenelse{\equal{\my@title@kind@ru}{comparison}}
                                {в форме \enquote{Сравнение}}
                                {в форме \enquote{Теоретическое исследование}}
                            }
                        }
                    }
                }\\
            {\normalsize \raggedleft
            \vskip 5em
            Научный руководитель:\\
            \my@title@supervisorPosition@ru\ \my@title@supervisor@ru\\
            \ifthenelse{\equal{\my@title@consultant@ru}{}}
            {}
            {
                \ifthenelse{\equal{\my@title@consultant@ru}{\my@title@supervisor@ru}}
                {\PackageError{matmex-diploma-custom}{Косультант и научник не могут быть одним и тем же физическим лицом. Скорее всего у Вас нет консультанта, и его указывать не нужно}{}}
                {
                    \vskip 1em
                    Консультант:\\
                    \my@title@consultantPosition@ru\ \my@title@consultant@ru\\
                }
            }
            }
            }
            {
            {\Large\textbf{\textit{\my@title@author@ru}}}
            \vskip 1em
                {\large Выпускная квалификационная работа}
            \vskip 1em
                {\Huge \@title}

            \vskip 2em
            Уровень образования: \ifthenelse{\equal{\my@title@type@ru}{master}}{магистратура}{бакалавриат}

            \vskip 1em

            Направление \textit{\my@title@specialty@ru}

            \vskip 1em

            Основная образовательная программа \textit{\my@title@programme@ru}

            \vskip 1em

            \ifthenelse{\equal{\my@title@profile@ru}{}}{}{Профиль \underline{\textit{\my@title@profile@ru}}}

            {\normalsize \raggedleft
                \vskip 5em
                Научный руководитель:\\
                \my@title@supervisorPosition@ru\ \my@title@supervisor@ru\\
                \vskip 1em
                Рецензент:\\
                \my@title@reviewerPosition@ru\ \my@title@reviewer@ru\\
            }
            }
        \end{center}
    \end{titlepage}
}

% Титульная страница на английском языке
\newcommand\maketitleen{
    \fancypagestyle{titleen}{
        \fancyhf{}  % clear all header and footer fields
        \renewcommand{\headrulewidth}{0pt}  % remove head ruler
        %% В верхнем колонтитуле будет университет, кафедра и группа, если это курсовая/практика, или просто университет для ВКР
        \chead{\large
            Saint Petersburg State University
            \vskip 1em
            \ifthenelse{\equal{\my@title@type@en}{bachelor} \OR \equal{\my@title@type@en}{master}}
            {}
            {
                {\large \my@title@chair@en }
                \vskip 1em
                    {\large Group \my@title@group@en }
            }
        }
        %% В нижнем колонтитуле город и год
        \cfoot{\large\parbox[b]{\textwidth}{\centering Saint Petersburg\\ \my@title@year@en}}
    }
    \title{\my@title@title@en}
    \begin{titlepage}%
        \newgeometry{top=20mm,bottom=20mm,left=20mm,right=15mm,nohead,includeheadfoot}
        \thispagestyle{titleen}
        \begin{center}

            \vspace*{0.25\textheight}

            \ifthenelse{\equal{\my@title@type@en}{coursework} \OR \equal{\my@title@type@en}{practice} \OR \equal{\my@title@type@en}{production} \OR \equal{\my@title@type@en}{prediploma}}
            {
            {\Large\textbf{\textit{\my@title@author@en}}}
            \vskip 2em
                {\Huge \@title}
            \vskip 1em
                {\large
                    \ifthenelse{\equal{\my@title@type@en}{coursework}}
                    {Coursework}
                    {\ifthenelse{\equal{\my@title@type@en}{practice}}
                        {Internship report}
                        {Pre-Diploma practice report}
                    }\\
                    \ifthenelse{\equal{\my@title@kind@en}{solution}}
                    {in a \foreignquote{english}{Solution} form}
                    {\ifthenelse{\equal{\my@title@kind@en}{experiment}}
                        {in an \foreignquote{english}{Experiment} form}
                        {\ifthenelse{\equal{\my@title@kind@en}{production}}
                            {in a \foreignquote{english}{Production} form}
                            {\ifthenelse{\equal{\my@title@kind@en}{comparison}}
                                {in a \foreignquote{english}{Comparison} form}
                                {in a \foreignquote{english}{Theoretical research} form}
                            }
                        }
                    }

                }\\
            {\normalsize \raggedleft
            \vskip 5em
            Scientific supervisor:\\
            \my@title@supervisorPosition@en\ \my@title@supervisor@en\\
            \ifthenelse{\equal{\my@title@consultant@en}{}}
            {}
            {
                \vskip 1em
                Consultant:\\
                \my@title@consultantPosition@en\ \my@title@consultant@en\\
            }
            }
            }
            {
            {\Large\textbf{\textit{\my@title@author@en}}}
            \vskip 1em
                {\large \ifthenelse{\equal{\my@title@type@en}{master}}{Master's Thesis}{Bachelor's Thesis}}
            \vskip 1em
                {\Huge \@title}

            \vskip 2em
            Education level: \ifthenelse{\equal{\my@title@type@en}{master}}{master}{bachelor}

            \vskip 1em

            Speciality \textit{\my@title@specialty@en}

            \vskip 1em

            Programme \textit{\my@title@programme@en}

            \vskip 1em

            \ifthenelse{\equal{\my@title@profile@en}{}}{}{Profile: \underline{\textit{\my@title@profile@en}}}

            {\normalsize \raggedleft
                \vskip 5em
                Scientific supervisor:\\
                \my@title@supervisorPosition@en\ \my@title@supervisor@en\\
                \vskip 1em
                Reviewer:\\
                \my@title@reviewerPosition@en\ \my@title@reviewer@en\\
            }
            }
        \end{center}
    \end{titlepage}
}

%% Титульный лист генерируется, если для соответствующего языка
%% определен аргумент title
%% Счетчик страниц автоматически увеличивается при генерации титульнго листа
\renewcommand\maketitle{
    %% На титульной странице все кроме полей соответствует \documentclass[12pt]{article}
    \my@title12pt
    \newcounter{titlepages}
    \setcounter{titlepages}{1}
    \begin{spacing}{1.0}
        \ifthenelse{\isundefined{\my@title@title@ru}}{}{
            % fancyhdr set height of the top/bottom headers automatically
            % so set them to zero to be sure that he does it
            \setlength{\headheight}{0pt}
            \setlength{\footskip}{0pt}
            \maketitleru\addtocounter{titlepages}{1}
        }
        \ifthenelse{\isundefined{\my@title@title@en} \OR \equal{\my@title@type@ru}{coursework} \OR \equal{\my@title@type@ru}{practice} \OR \equal{\my@title@type@ru}{production} \OR \equal{\my@title@type@ru}{prediploma}}{}{
            % fancyhdr already set height of the top/bottom headers on the previous page (titleru)
            % but on this page the headers' height might be different
            % so set them to zero again in order to make fancyhdr to do it
            \setlength{\headheight}{0pt}
            \setlength{\footskip}{0pt}
            \maketitleen\addtocounter{titlepages}{1}
        }
    \end{spacing}
    \setcounter{page}{\value{titlepages}}
    % restore preamble's geometry
    \my@body14pt
    \newgeometry{top=20mm,bottom=20mm,left=30mm,right=15mm,nohead,includeheadfoot}
}

%% Каждая глава начинается с новой страницы, введение и заключение не
%% нумеруются, но в оглавление входят. А само оглавление в оглавление не входит
\let\old@section\section
\def\section{\@ifstar\@section\@@section}
\def\@section#1{\newpage\old@section*{#1}%
    \ifthenelse{\equal{#1}{\contentsname}}%
    {}%
    {\addcontentsline{toc}{section}{#1}}%
}
\def\@@section#1{\newpage\old@section{#1}}

%% Полуторный интервал
\usepackage[nodisplayskipstretch]{setspace}
\onehalfspacing

%% Переименование "содержания" в "оглавление"
\gappto\captionsrussian{\renewcommand{\contentsname}{Оглавление}}

\let\savenumberline\numberline
\def\numberline#1{\savenumberline{#1.}}

%% Запретим тексту выезжать на поля вообще и совсем
\sloppy

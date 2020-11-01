\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{matmex-diploma-custom}[2015/05/28 MatMex LaTeX diploma class]
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


\usepackage{iftex}
\ifXeTeX
  %% Мы используем компилятор XeLaTex, который дружит с Unicode и True Type/Open Type
  %% шрифтами. Для русификации достаточно подключить пакет fontspec и
  %% выбрать Unicode шрифт в котором есть кириллические глифы. Ниже
  %% основным шрифтом выбирается Unicode версия шрифта Computer Modern с заcечками
  \usepackage{fontspec}
  \setmainfont[Mapping=tex-text]{CMU Serif}
  \setmonofont[Mapping=tex-text]{CMU Typewriter Text}
  %\setmonofont{Fira Code}[Contextuals=Alternate,Scale=0.9]
  %\setmonofont{Inconsolata}
  %\newfontfamily\cyrillicfont{CMU Serif}
  %% В XeLaTex заменой известного пакета babel является пакет polyglossia.
  %% Теперь у нас будут переносы слов
  \usepackage{polyglossia}
  \setdefaultlanguage{russian}
  \setotherlanguage{english}
\else 
  \PackageError{mypackage}{use XeLaTeX}{}
\fi


% \addto\captionsrussian{%
%   \renewcommand{\figurename}{Рис.}%
%   \renewcommand{\tablename}{Табл.}%
% }

%% Отступ в первом абзаце
\usepackage{indentfirst}
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

%% Параметры заполнения титульного листа
\usepackage{xkeyval}

%% Русскоязычный вариант
\define@key[ru]{mytitle}{university}{\def\my@title@university@ru{#1}}
\define@key[ru]{mytitle}{faculty}{\def\my@title@faculty@ru{#1}}
\define@key[ru]{mytitle}{chair}{\def\my@title@chair@ru{#1}}
\define@key[ru]{mytitle}{title}{\def\my@title@title@ru{#1}}
\define@key[ru]{mytitle}{position}{\def\my@title@position@ru{#1}}
\define@key[ru]{mytitle}{group}{\def\my@title@group@ru{#1}}
\define@key[ru]{mytitle}{author}{\def\my@title@author@ru{#1}}
\define@key[ru]{mytitle}{supervisor}{\def\my@title@supervisor@ru{#1}}
\define@key[ru]{mytitle}{supervisorPosition}{\def\my@title@supervisorPosition@ru{#1}}
\define@key[ru]{mytitle}{reviewer}{\def\my@title@reviewer@ru{#1}}
\define@key[ru]{mytitle}{reviewerPosition}{\def\my@title@reviewerPosition@ru{#1}}
\define@key[ru]{mytitle}{chairHead}{\def\my@title@chairHead@ru{#1}}
\define@key[ru]{mytitle}{chairHeadPosition}{\def\my@title@chairHeadPosition@ru{#1}}
\define@key[ru]{mytitle}{year}{\def\my@title@year@ru{#1}}
\define@key[ru]{mytitle}{city}{\def\my@title@city@ru{#1}}
\define@choicekey*[ru]{mytitle}{type}{diploma,coursework,master,bachelor,vkr}{\def\my@title@type@ru{#1}}

%% Англоязычный вариант
\define@key[en]{mytitle}{university}{\def\my@title@university@en{#1}}
\define@key[en]{mytitle}{faculty}{\def\my@title@faculty@en{#1}}
\define@key[en]{mytitle}{chair}{\def\my@title@chair@en{#1}}
\define@key[en]{mytitle}{title}{\def\my@title@title@en{#1}}
\define@key[en]{mytitle}{position}{\def\my@title@position@en{#1}}
\define@key[en]{mytitle}{group}{\def\my@title@group@en{#1}}
\define@key[en]{mytitle}{author}{\def\my@title@author@en{#1}}
\define@key[en]{mytitle}{supervisor}{\def\my@title@supervisor@en{#1}}
\define@key[en]{mytitle}{supervisorPosition}{\def\my@title@supervisorPosition@en{#1}}
\define@key[en]{mytitle}{reviewer}{\def\my@title@reviewer@en{#1}}
\define@key[en]{mytitle}{reviewerPosition}{\def\my@title@reviewerPosition@en{#1}}
\define@key[en]{mytitle}{chairHead}{\def\my@title@chairHead@en{#1}}
\define@key[en]{mytitle}{chairHeadPosition}{\def\my@title@chairHeadPosition@en{#1}}
\define@key[en]{mytitle}{year}{\def\my@title@year@en{#1}}
\define@key[en]{mytitle}{city}{\def\my@title@city@en{#1}}
\define@choicekey*[en]{mytitle}{type}{diploma,coursework,master,bachelor}{\def\my@title@type@en{#1}}

\newcommand\filltitle[2]{
%% Значения по умолчанию для обоих языков
    \ifthenelse{\equal{#1}{ru}}
        {
        \presetkeys[#1]{mytitle}{
          university = {Санкт-Петербургский государственный университет},
          faculty = {},
          city = {Санкт-Петербург},
          year = {\the\year},
          type = {diploma}
        }{}
        }
        {}
    \ifthenelse{\equal{#1}{en}}
        {
        \presetkeys[#1]{mytitle}{
          university = {SAINT-PETERSBURG STATE UNIVERSITY},
          faculty = {},
          city = {Saint-Petersburg},
          year = {\the\year},
          type = {diploma}
        }{}
        }
        {}
    \setkeys[#1]{mytitle}{#2}
}

%% Титульная страница на русском языке
\newcommand\maketitleru{
\fancypagestyle{titleru}{
    \fancyhf{}  % clear all header and footer fields
    \renewcommand{\headrulewidth}{0pt}  % remove head ruler
    % В верхнем колонтитуле будет университет и кафедра
    \chead{\large 
      \my@title@university@ru 
      \ifthenelse{\equal{\my@title@faculty@ru}{}}{}{\my@title@faculty@ru }
      \vskip 1em
      {\large \my@title@chair@ru }
    }
    % В нижнем колонтитуле город и год
    \cfoot{\large\parbox[b]{\textwidth}{\centering \my@title@city@ru\\ \my@title@year@ru}}
}

\title{\my@title@title@ru}
\begin{titlepage}
\newgeometry{top=20mm,bottom=20mm,left=20mm,right=15mm,nohead,includeheadfoot}
\thispagestyle{titleru}
\begin{center}
    \vspace*{0.25\textheight}
    {\Large\textbf{\textit{\my@title@author@ru}}}
    \vskip 1em
    {\large 
    \ifthenelse{\equal{\my@title@type@ru}{coursework}}
    {Курсовая работа}
    {\ifthenelse{\equal{\my@title@type@ru}{diploma}}
    {Отчёт по преддипломной практике}
    % {\ifthenelse{\equal{\my@title@type@ru}{subdiploma}}
    % {Отчёт по преддипломной практике}
    {\ifthenelse{\equal{\my@title@type@ru}{master}}
    {Магистерская диссертация}
    {\ifthenelse{\equal{\my@title@type@ru}{bachelor}}
    {Выпускная квалификационная работа бакалавра}
    {\ifthenelse{\equal{\my@title@type@ru}{vkr}}
    {\Large \textbf{Выпускная квалификационная работа}}
    }}}}
    \\}
    
    \vskip 2em
    {\Huge \@title}

    \vskip 2em
    { Уровень образования:\\Направление \textit{09.06.01 }}

    \vskip 2em
    { Основная образовательная программа  \\}
    \textit{``Информатика и вычислительная техника''}

    \vskip 2em
    \ifthenelse{\equal{\my@title@type@ru}{coursework}}
    {\normalsize \raggedleft 
    Научный руководитель:\\
    \my@title@supervisorPosition@ru\ \my@title@supervisor@ru\sigspace
    Консультант:\\% TODO: сделать консультанта опциональным
    \my@title@reviewerPosition@ru\ \my@title@reviewer@ru
    }
    {\normalsize \raggedleft 
    \vskip 5em
    Научный руководитель:\\
    \my@title@supervisorPosition@ru\ \my@title@supervisor@ru\sigspace
    Рецензент:\\
    \my@title@reviewerPosition@ru\ \my@title@reviewer@ru
    }
\end{center}
\end{titlepage}
}

%% Титульная страница на английском языке
\newcommand\maketitleen{
\fancypagestyle{titleen}{
    \fancyhf{}  % clear all header and footer fields
    \renewcommand{\headrulewidth}{0pt}  % remove head ruler
    %% В верхнем колонтитуле будет университет и кафедра
    \chead{\large 
        \my@title@university@en \\ 
        \ifthenelse{\equal{\my@title@faculty@en}{}}{}{\my@title@faculty@en \\}  
        \vskip 1em
        {\large \my@title@chair@en \\}
    }
    %% В нижнем колонтитуле город и год
    \cfoot{\large\parbox[b]{\textwidth}{\centering \my@title@city@en\\ \my@title@year@en}}
}
\title{\my@title@title@en}
\begin{titlepage}%
\newgeometry{top=20mm,bottom=20mm,left=20mm,right=15mm,nohead,includeheadfoot}
\thispagestyle{titleen}
  \begin{center}
    \vspace*{0.25\textheight}
    {\Large\my@title@author@en\\}
    
    \vskip 2em
    {\Huge \@title \\}
    
    \vskip 1em
    {\large 
    \ifthenelse{\equal{\my@title@type@en}{coursework}}
    {Course Work}
    {\ifthenelse{\equal{\my@title@type@en}{diploma}}
    {Bachelor's thesis}
    {\ifthenelse{\equal{\my@title@type@en}{master}}
    {Master's Thesis}
    {\ifthenelse{\equal{\my@title@type@en}{bachelor}}
    {Bachelor's Thesis}
    }}}
    \\}
    \vskip 2em
    \ifthenelse{\equal{\my@title@type@en}{coursework}}
    {\normalsize \raggedleft 
    Scientific supervisor:\\
    \my@title@supervisorPosition@en\ \my@title@supervisor@en
    }
    {\normalsize \raggedleft 
    \vskip 5em
    Scientific supervisor:\\
    \my@title@supervisorPosition@en\ \my@title@supervisor@en\sigspace

    Reviewer:\\
    \my@title@reviewerPosition@en\ \my@title@reviewer@en
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
\ifthenelse{\isundefined{\my@title@title@en}}{}{
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

Git hooks {#githooks}

[TOC]

## Software requirements

* Qt 5.x and Qt Creator - download the Qt Online Installer from https://www.qt.io/download-open-source/
* Python3 (tested on Python 3.5.2)
* clang-format-3.8 		  --> sudo apt install clang-format-3.8
* clang-tidy-3.8   		  --> sudo apt install clang-tidy-3.8
* bear (for qmake based projects) --> https://github.com/rizsotto/Bear
* git


**Note:** on GitLab CI required software is already installed.

## Step by step guide

1. Copy into your repository, scripts from https://git.milosolutions.com/milo-code-database/mscripts/tree/master/hooks
2. Install mclang-format.py and mclang-tidy.py as one pre-commit hook using mgit-hooks-installer.py script
```
$ ./scripts/mgit-hooks-installer.py
pre-commit hook has been installed
```
3. Modify milo/mscripts/hooks/mconfig.py and add your clang version number. It is not guessed automatically.
4. After changes in your working repository , call like always
```
git add .
git commit -m "Provide good commit message"
```
at the moment git will call pre-commit hook from .git/hooks, in our case it will call accordingly
* mclang-format
* mclang-tidy (only when previous step was finished succesful)
4. If your code has a proper formatting and does not contains any errors then you should see

```
$ git add .
$ git commit -m "Update main.cpp"
Running mclang-format...
no modified files to format

=== 0 error(s) was found

Running mclang-tidy...
No relevant changes found.


=== 0 error(s) and 0 warning(s) was found

[master fdaafc5] Update main.cpp
 1 file changed, 4 deletions(-)
```


otherwise you should see summary with the number of error(s) and/or warning(s) and details about places
where these error(s) occurs.

* mclang-format:

```
$ git add .
$ git commit -m "Update main.cpp"
Running mclang-format...
diff --git a/main.cpp b/main.cpp
index 164d2d7..4981566 100644
--- a/main.cpp
+++ b/main.cpp
@@ -1,13 +1,10 @@
 #include <QCoreApplication>
 #include <QDebug>

-bool authenticate(const QString &user)
-{
-    return user == "MILO";
-}
+bool authenticate(const QString &user) { return user == "MILO"; }

 int main(int argc, char *argv[]) {
-  QCoreApplication a    (argc,  argv);
+  QCoreApplication a(argc, argv);

   qDebug() << authenticate("MILO");
   return;

=== 2 error(s) was found
```

* mclang-tidy:

```
$ git add .
$ git commit -m "Update main.cpp"
Running mclang-format...
clang-format did not modify any files

=== 0 error(s) was found

Running mclang-tidy...
15031 warnings and 2 errors generated.
Error while processing /home/c50/Desktop/02/mclang_tidy/main.cpp.
Suppressed 15031 warnings (15031 in non-user code).
Use -header-filter=.* to display errors from all non-system headers.
/home/c50/Desktop/02/mclang_tidy/main.cpp:9:15: error: no matching function for call to 'authenticate' [clang-diagnostic-error]
  qDebug() << authenticate('MILO');
              ^
/home/c50/Desktop/02/mclang_tidy/main.cpp:4:6: note: candidate function not viable: no known conversion from 'int' to 'const QString' for 1st argument
bool authenticate(const QString &user) { return user == "MILO"; }
     ^
/home/c50/Desktop/02/mclang_tidy/main.cpp:10:3: error: non-void function 'main' should return a value [clang-diagnostic-return-type]
  return;
  ^


=== 2 error(s) and 0 warning(s) was found
```

## Integrating with GitLab CI

Integrating mclang-format.py and mclang-tidy.py with GitLab CI architecture is very easy. All what you need is to create ''.gitlab-ci.yml'' script inside root folder of you repository, example of proper .gitlab-ci.yml script:

```
stages:
- clang-format
- clang-tidy

clang-format_job:
  stage: clang-format
  script:
    - ./scripts/mclang-format.py

  tags:
    - Docs

clang-tidy_job:
  stage: clang-tidy
  script:
    - ./scripts/mclang-tidy.py

  when: always

  tags:
    - Docs
```

more about GitLab CI, structure of .yml script, stages, tags and other variables:
* stages https://docs.gitlab.com/ee/ci/yaml/#stages
* jobs https://docs.gitlab.com/ee/ci/yaml/#jobs
* tags https://docs.gitlab.com/ee/ci/yaml/#tags
* general guide about GitLab CI https://docs.gitlab.com/ce/ci/quick_start/README.html
* general guide about .gitlab-ci.yml https://docs.gitlab.com/ee/ci/yaml/

## How to temporary avoid clang-format and clang-tidy without removing them from hooks

If you will have a code which can not be formatting, for example you have custom annotations together with parser which require specific format of annotations, then you can use --no-verify git option, see https://git-scm.com/docs/githooks#_pre_commit

```
c50@c50-tosh ~/Desktop/02/CI-lab $ git add .
c50@c50-tosh ~/Desktop/02/CI-lab $ git commit -m "Update main.cpp" --no-verify
[master 1b010d2] Update main.cpp
 1 file changed, 2 insertions(+), 2 deletions(-)
```

## Know issues

For any first change locally (before "mclang_tidy" directory is created) it gives logs as below.
When you try second time (again try commit) it will finish successfully.

* stdout:

```
Running mclang-format...
clang-format did not modify any files

=== 0 error(s) was found

g++ -c -pipe -O2 -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_NO_DEBUG -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB -I. -I../../Qt/5.8/gcc_64/include -
I../../Qt/5.8/gcc_64/include/QtWidgets -I../../Qt/5.8/gcc_64/include/QtGui -I../../Qt/5.8/gcc_64/include/QtCore -I. -isystem /usr/include/libdrm -I../../Qt/5.8/gcc_64/mkspecs/linux-g++ -o main.o
main.cpp
g++ -c -pipe -O2 -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_NO_DEBUG -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB -I. -I../../Qt/5.8/gcc_64/include -
I../../Qt/5.8/gcc_64/include/QtWidgets -I../../Qt/5.8/gcc_64/include/QtGui -I../../Qt/5.8/gcc_64/include/QtCore -I. -isystem /usr/include/libdrm -I../../Qt/5.8/gcc_64/mkspecs/linux-g++ -o mainwindow.o
mainwindow.cpp
g++ -Wl,-O1 -Wl,-rpath,/home/administrator/Qt/5.8/gcc_64/lib -o hooks_test main.o mainwindow.o moc_mainwindow.o   -L/home/administrator/Qt/5.8/gcc_64/lib -lQt5Widgets -lQt5Gui -lQt5Core -lGL -lpthread

Running mclang-tidy...
/usr/lib/gcc/x86_64-linux-gnu/5.4.0/../../../../include/c++/5.4.0/cstddef:45:10: error: 'stddef.h' file not found [clang-diagnostic-error]
#include <stddef.h>
         ^


=== 1 error(s) and 0 warning(s) was found
```

* stderr:

```
5347 warnings and 1 error generated.
Error while processing /home/administrator/git/mclang_tidy/main.cpp.
Suppressed 5347 warnings (5346 in non-user code, 1 due to line filter).
Use -header-filter=.* to display errors from all non-system headers.
```

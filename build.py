import os,time
filepath = '.\\web\\assets\\article'
filelist = os.listdir(filepath)
timelist = []
for i in filelist:
    timeclick = os.path.getmtime('.\\web\\assets\\article\\'+i)
    loacl_time = time.localtime(timeclick)
    timelist.append(time.strftime("%Y.%m.%d",loacl_time))
towrite = "["
topub = """
name: flutter_web_home
description: "Lyu Web Home"
publish_to: 'none' 
version: 1.0.0+1

environment:
  sdk: '>=3.4.3 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.6
  dynamic_color: ^1.7.0
  url_launcher: ^6.3.0
  fluttertoast: ^8.2.6
  flutter_markdown: ^0.7.2+1
  path_provider: ^2.1.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
flutter:

  uses-material-design: true
      
  assets:
  - ./web/assets/Article.png
  - ./web/assets/files.json
  """

def wordonly(context):
    context = context.split(' ', 1)
    result = context[-1]
    result = result.strip('\n')
    print(result)
    return result

for i in range(len(filelist)):
    filename = filelist[i]
    filetime = timelist[i]
    file = open('.\\web\\assets\\article\\%s' % filename , 'r',encoding = "utf-8")
    filetitle = file.readline()
    filetitle = wordonly(filetitle)
    file1stline = file.readline()
    file1stline = wordonly(file1stline)
    towrite += """
    {
      "link": "%s",
      "info": "%s",
      "title": "%s",
      "intro": "%s"
    }""" % (filename,filetime,filetitle,file1stline)
    topub += "- ./web/assets/article/%s" % filename
    if i+1 != len(filelist):
        towrite += ',\n'
    else:
        towrite += '\n'
towrite += '  ]'
js = open('.\\web\\assets\\files.json', 'wt',encoding = "utf-8")
js.write(towrite)
js.close()


pub = open('pubspec.yaml','wt',encoding='utf-8')
pub.write(topub)
pub.close()

os.system('flutter build web')
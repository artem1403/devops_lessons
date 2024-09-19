# Jenkins
## Задание

Создать 2 задачи Jenkins:
* Первая задача должна собирать Docker образ с заданным тегом (например v1.0), на сборочной ноде, и пушить его в registry.
* Вторая задача должна пулить (подтягивать) Docker образ с требуемым тегом из registry и запускать контейнер на продовой ноде.


### Процесс выполнения
Ищем самый новый стабильный релиз дженкинса

https://www.digitalocean.com/community/tutorials/how-to-install-jenkins-on-ubuntu-20-04

Скачиваем, ставим
```bash
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
apt install default-jdk
apt install jenkins
```

Создаем вторую ВМ, связываем её ключами, чтобы можно было подключаться по ssh.
Заходим в веб-интерфейс дженкинса, по IP-адресу машины, порт 8080
Настраиваем там логины и пароли, всё просто.

Дальше что?
* Ставим плагин ssh. Управление плагинами, доступные, SSH
* Добавляем вторую машину. Глобальные настройки, SSh remote hosts, там добавляем

На вторую ВМ ставим docker.io

В дженкинсе делаем джоб для сборки, ставим галочку "Это параметризированная сборка", там указываем параметр
далее в самой команде пишем:
```
docker pull hello-world:$docker_image_tag
```

#### Резвернем registry (Nexus Repo)
docker-compose.yml

version: "2"

services:
  nexus:
    image: sonatype/nexus3
    volumes:
      - "nexus-data:/nexus-data"
    ports:
      - "8081:8081"
      - "8123:8123"

volumes:
  nexus-data: {}


Поднять и зайти по адресу айпи:8081
Так не сработало, поднял просто контейнер
docker run -d -p 8081:8081 --name nexus sonatype/nexus3
сам контейнер работает. В документации написано, что это может занять 2-3 минуты чтобы он там настроился.

В браузере должен отобразиться интерфейс.
Пробуем зайти справа вверху, логин 
admin
А вот за паролем надо сходить в volume контейнера, чтобы его там найти.

Для этого делаем
`docker ps`, берем оттуда имя контейнера
далее делаем `docker inspect имя`, получаем кучу текста и ищем блок

"Mounts": [
            {
                "Type": "volume",
                "Name": "f882ba2d2fe831a1b75351896d371bb29b964ac671a6c187f3eec4ed7c25d7c3",
                "Source": "/var/lib/docker/volumes/f882ba2d2fe831a1b75351896d371bb29b964ac671a6c187f3eec4ed7c25d7c3/_data",
                "Destination": "/nexus-data",
                "Driver": "local",
                "Mode": "",
                "RW": true,
                "Propagation": ""
            }
]

Вот где указан путь, берем его, и переходим по нему через `cd`
Когда перешли, делаем `ls -la`
и там должен лежать файл admin.password
Открываем его через `nano admin.password`
Там должна быть строчка вида:

7be4ba3e-2ce6-4ec3-a178-763672f8c7b3

Копируем её и вставляем в поле пароля.
ЗАЛОГИНИЛИСЬ!

дальше по видео создаем репозиторий.
ОК, репозиторий настроен.

Заходим на машину с контейнером, и проверяем команды, что мы можем залогиниться
`docker login 34.69.239.62:8123 -u admin -p yjdsqgfhjkm1`

Если получаем ошибку
"server gave HTTP response to HTTPS client"
То пробуем следующее

>    Create or modify /etc/docker/daemon.json
>    { "insecure-registries":["myregistry.example.com:5000"] }
>    Restart docker daemon
>    sudo service docker restart


И можем протегировать свой образ и запушить туда
`docker tag hello-world 34.69.239.62:8123/hello-world`
`docker push 34.69.239.62:8123/hello-world`

Явно указывать тег вот таким образом 
docker tag hello-world:linux 34.69.239.62:8123/hello-world:linux

Слева тег указываем для нашего образа
А справа, как мы его запишем в репозитории

### Продакшн ВМ
Поднимаем ВМ
Ставим докер.
Меняем конфиг файл 
etc/docker/daemon.json
>    { "insecure-registries":["34.122.61.217:8123"] }
делаем рестарт докера

Соединяем ключом с мастер-нодой (где дженкинс)
Заходим в дженкинс, прописываем новый креденшиал
Далее в дженкинсе создаем новое подключение ssh
Далее в шаге сборки делаем еще один шаг выполнения на удаленной машине

В скрипте авторизуемся в нексусе командой 
`docker login 34.122.61.217:8123 -u admin -p yjdsqgfhjkm1`

выкачивать и сразу запускать контейнер можно командой
`docker run 34.122.61.217:8123/hello-world:latest`
# Урок 12
задание на docker-compose
Берем приложение
https://github.com/shephertz/App42PaaS-Java-MySQL-Sample

Необходимо контейнерезировать вот это приложение, и оно должно работать. 

## Git submodules
Добавление подмодуля
```bash
git submodule add https://github.com/shephertz/App42PaaS-Java-MySQL-Sample.git
```
При клонировании проекта с подмодулем делаем следующее
```bash
git submodule init
git submodule update
```

## Команды для Docker
```bash
docker kill $(docker ps -q) -- выключить все запущенные контейнеры
docker rm $(docker ps -a -q) -- удалить все остановленные контейнеры
docker system prune -a -- удалить всех неиспользуемых волюмов и образов
```


## Процесс выполнения

Итак, нам понадобится: 

* Контейнер в maven, где мы будем собирать приложение. Или соберем вручную и сразу будем работать с war-файлом?
* Контейнер с Java 6 и Tomcat, чтобы в нём расположить само приложение. war-файл загрузим снаружи.
* Контейнер с MySQL (какой версии?) Чтобы приложение приложение смотрело в него (по порту в файле конфига app../WebContent/Config.properties)




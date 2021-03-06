# Redmine Time Limit Plugin
Redmine Time Limit Plugin используется для контроля реального времени, проведенного сотрудником на рабочем месте.

## Функциональность
 * Новое право в настройках роли "Не использовать ограничение на списание времени"
 * Для начала отсчета времени (активирования таймера), нужно авторизоваться в Redmine через ip-адрес включенный в список “одобренных”.
 * Валидация списываемого времени. Запрещено списывать больше времени, чем на таймере.
 * Валидация наличия комментария при списывании времени
 * Запрет списывать время в определенных статусах.
 * Запрет списывать время с "не одобренных" IP-адресов

## Загрузка плагина
Плагин можно загрузить из Github https://github.com/twinslash/redmine_time_limit

## Установка
Для установки плагина нужно зайти в директорию plugins/ и клонировать репозиторий из Github:
```bash
cd REDMINE/plugins
git clone https://github.com/twinslash/redmine_time_limit.git
```

Выполнить миграции БД:
```bash
bundle exec rake redmine:plugins:migrate
```

Перезапустить Ваш Redmine сервер

## Удаление
Откатить изменения в базе данных
```bash
cd REDMINE
bundle exec rake redmine:plugins:migrate NAME=redmine_time_limit VERSION=0
```

Удалить папку с плагином
```bash
cd REDMINE/plugins
rm redmine_time_limit -rf
```

Перезапустить Ваш Redmine сервер

## Настройка
Данный плагин работает только для ролей у которых **отключено право "Редактирование собственного учёта времени" и "Редактирование учёта времени"**.

Если требуется для какой-то роли не использовать ограничение на списываемое время, то необходимо установить право "Не использовать ограничение на списание времени" на странице Администрирование->Роли и права доступа (Administration->Roles and permissions)

В настройках плагина Администрирование->Модули->Redmine Time Limit Plugin (Administration->Plugins->Redmine Time Limit Plugin) надо указать:
 * Указать IP-адреса, которые будут считаться "одобренными". IP-адреса могут задаваться в формате маски подсети
 * Указать список статусов, в которых запрещено списывать время. Если задача меняет статус, то время можно списать, если хотя бы один из статусов позволяет это сделать

## Использование
После того, как пользователь вошел в систему, у него в правом верхнем углу появляется таймер, в котором число часов слева - это проведенное время на рабочем месте, справа - число не списанных часов. Пользователь не может списать времени большее, чем количество не списанного времени.

При списывании времени необходимо, чтобы задача была в "разрешенном" статусе. Например, есть три статуса TODO, Working, Finish. Плагин позволяет списывать время только в статусе Working. Тогда порядок будет следующий:
 * пользователь открывает задачу в статусе TODO и меняет на статус Working
 * появляется блок для ввода времени
 * пользователь может проставить потраченные часы.
 * затем пользователь снова может открыть эту задачу и сменить статус на Finish, блок для списывания времени останется и время можно будет списать.

Если пользователь первый раз за день заходит с "не одобренного" IP-адреса, то таймер будет установлен в -99 часов и пользователь не будет иметь возможность списать время. Если же тот же пользователь в тот же день зайдет уже с "одобренного" IP-адреса, то таймер будет обнулен. И если опять тот же самый пользователь в тот же день зайдет с "не одобренного" IP то таймер не сбросится (и время будет накапливаться), но пользователь не сможет списать время с данного IP.

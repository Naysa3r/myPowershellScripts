#ConvertAddressBook

Конвертер адресной книги в формате vCard в eml файлы для импорта в пользовательские адреса Kerio Connect.
Для работы русского языка адресная книга должна быть в кодировке UTF-8 с BOM

ЗАПУСК: .\ConvertAddressBook.ps1 [Расположение книги формата .vcf] [Каталог для выходных данных]

Полученные файлы переносим на сервер Kerio Connect в каталог [/opt/kerio/mailserver/store/mail/domain.com/пользователь/Contacts/#msgs]
Переиндексируем пользователя через web-интерфейс Kerio Connect

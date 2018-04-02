///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Запуск тестирования через фреймворк xUnitFor1C
// 
//	oscript src/main.os xunit C:\projects\xUnitFor1C\Tests\Smoke --pathxunit C:\projects\xUnitFor1C\xddTestRunner.epf 
//		--reportsxunit "ГенераторОтчетаJUnitXML{build/junit.xml};ГенераторОтчетаAllureXML{build/allure.xml}"
//		--reportsxunit "GenerateReportJUnitXML{build/junit.xml};GenerateReportAllureXML{build/allure.xml}"
//
// TODO добавить фичи для проверки команды тестирования xUnitFor1C
//
// Служебный модуль с набором методов работы с командами приложения
//
// Структура модуля реализована в соответствии с рекомендациями 
// oscript-app-template (C) EvilBeaver
//
///////////////////////////////////////////////////////////////////////////////////////////////////

#Использовать logos
#Использовать v8runner
#Использовать asserts
#Использовать add
#Использовать fs

Перем Лог;
Перем МенеджерКонфигуратора;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт

	ТекстОписания = 
		"     Запуск тестирования через фреймворк xUnitFor1C
		|     ";

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ПараметрыСистемы.ВозможныеКоманды().Тестирование_xUnitFor1C, 
		ТекстОписания);

	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "testsPath", 
		"[env RUNNER_TESTSPATH] Путь к каталогу или к файлу с тестами 
		|или к встроенным тестам, если явно указан ключ --config-tests.
		|Возможные варианты указания подсистемы или конкретного теста:
		|	Метаданные.Подсистемы.Тестовая
		|	Метаданные.Подсистемы.Тестовая.Подсистемы.Подсистема1
		|	Метаданные.Обработки.Тест");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--workspace", 
		"
		|[env RUNNER_WORKSPACE] путь к папке, относительно которой будут определятся макросы $workspace.
		|                 по умолчанию текущий.");

	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--config-tests", 
		"[env RUNNER_CONFIG_TESTS] загружать тесты, встроенные в конфигурации в указанную подсистему");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--pathxunit", 
			"[env RUNNER_PATHXUNIT] путь к внешней обработке, по умолчанию ищу в пакете add");

	ОписаниеОтчетов = "    --reportsxunit параметры формирования отчетов в формате вида:";
	ОписаниеОтчетов  = ОписаниеОтчетов  + 
		"      ФорматВыводаОтчета{Путь к файлу отчета};ФорматВыводаОтчета{Путь к файлу отчета}...";
	ОписаниеОтчетов  = ОписаниеОтчетов  + 
		"      Пример:							ГенераторОтчетаJUnitXML{build/junit.xml};ГенераторОтчетаAllureXML{build/allure.xml}";
	ОписаниеОтчетов  = ОписаниеОтчетов  + 
		"      Пример (англоязычный вариант):	GenerateReportJUnitXML{build/junit.xml};GenerateReportAllureXML{build/allure.xml}";
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--reportsxunit", ОписаниеОтчетов);
	
	ОписаниеСтатуса = "    --xddExitCodePath путь к текстовому файлу, обозначающему статус выполнению.";
	ОписаниеСтатуса  = ОписаниеСтатуса  + "    Внутри файла строка-значение 0 (тесты пройдены), 1 (тесты не пройдены)";
	
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--xddExitCodePath", ОписаниеСтатуса);
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--xddConfig", "Путь к конфигурационному файлу xUnitFor1c");

	ОписаниеТестКлиент = "Параметры подключения к тест-клиенту вида --testclient ИмяПользователя:Пароль:Порт";
	ОписаниеТестКлиент = ОписаниеТестКлиент + 
		"    Пример 1: --testclient Администратор:пароль:1538";
	ОписаниеТестКлиент = ОписаниеТестКлиент + 
		"    Пример 2: --testclient ::1538 (клиент тестирования будет запущен с реквизитами менеджера тестирования)";
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--testclient", ОписаниеТестКлиент);

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, 
			"--reportxunit", "путь к каталогу с отчетом jUnit (устарел)");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--additional", 
			"Дополнительные параметры для запуска предприятия.");
	
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--no-wait", 
		"Не ожидать завершения запущенной команды/действия");

	Парсер.ДобавитьКоманду(ОписаниеКоманды);
	
КонецПроцедуры // ЗарегистрироватьКоманду

// Выполняет логику команды
// 
// Параметры:
//   ПараметрыКоманды - Соответствие - Соответствие ключей командной строки и их значений
//   ДополнительныеПараметры - Соответствие - дополнительные параметры (необязательно)
//
Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры = Неопределено) Экспорт

	Попытка
		Лог = ДополнительныеПараметры.Лог;
	Исключение
		Лог = Логирование.ПолучитьЛог(ПараметрыСистемы.ИмяЛогаСистемы());
	КонецПопытки;
	

	ЗапускатьТолстыйКлиент = ОбщиеМетоды.УказанПараметрТолстыйКлиент(ПараметрыКоманды["--ordinaryapp"], Лог);
	ОжидатьЗавершения = Не ПараметрыКоманды["--no-wait"];

	ПараметрыОтчетовXUnit = ПараметрыОтчетовXUnit(ПараметрыКоманды["--reportsxunit"], 
			ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["--reportxunit"]));

	ОбеспечитьСуществованиеРодительскихКаталоговДляПутей(ПараметрыОтчетовXUnit);

	ДанныеПодключения = ПараметрыКоманды["ДанныеПодключения"];
	
	МенеджерКонфигуратора = Новый МенеджерКонфигуратора;
	МенеджерКонфигуратора.Инициализация(
		ДанныеПодключения.СтрокаПодключения, ДанныеПодключения.Пользователь, ДанныеПодключения.Пароль,
		ПараметрыКоманды["--v8version"], ,
		ДанныеПодключения.КодЯзыка, ДанныеПодключения.КодЯзыкаСеанса
	);

	Попытка
		ЗапуститьТестироватьЮнит(
			ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["testsPath"]), 
			ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["--workspace"]),
			ПараметрыОтчетовXUnit,
			ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["--xddExitCodePath"]),
			ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["--pathxunit"]), ЗапускатьТолстыйКлиент,
			ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["--xddConfig"]), 
			ОжидатьЗавершения,
			ПараметрыКоманды["--additional"],
			ПараметрыКоманды["--config-tests"],
			ПараметрыКоманды["--testclient"]
		);
	Исключение
		МенеджерКонфигуратора.Деструктор();
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;

	МенеджерКонфигуратора.Деструктор();

	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;
КонецФункции // ВыполнитьКоманду

// Выполняем запуск тестов для xunit 
//
// Параметры:
//	ПутьВходящихДанных - <Строка> - Может принимать путь к каталогу, так и к файлу для тестирования, 
//		или пути к встроенным тестам
//	РабочийКаталогПроекта - <Строка> - Путь к каталогу с проектом, по умолчанию каталог ./
//	ФормируемыеОтчеты - <Структура> - Коллекция описания формирования отчетов тестирования
//  ПутьФайлаСтатусаТестирования - <Строка> - путь к файлу статуса тестирования
//  ПутьКИнструментам - <Строка> - путь к инструментам, по умолчанию ./tools/xUnitFor1C/xddTestRunner.epf
//  ТолстыйКлиент - <Булево> - признак запуска толстого клиента
//	ДопПараметры - <Строка> - дополнительные параметры для передачи в параметры запуска 1с, например /DebugURLtcp://localhost
//  ЗагружатьВстроенныеТесты - <Булево> - Загружать тесты, встроенные в конфигурацию
//  ТестКлиент - <Строка> - Параметры подключения к тест-клиенту
//
Процедура ЗапуститьТестироватьЮнит(Знач ПутьВходящихДанных, 
										Знач РабочийКаталогПроекта,
										Знач ФормируемыеОтчеты,
										Знач ПутьФайлаСтатусаТестирования,
										Знач ПутьКИнструментам = "", Знач ТолстыйКлиент = Ложь, 
										Знач ПутьККонфигурационномуФайлу,
										Знач ОжидатьЗавершения = Истина,
										Знач ДопПараметры="",
										Знач ЗагружатьВстроенныеТесты = Истина,
										Знач ТестКлиент = "")

	Лог.Информация("Выполняю тесты %1", ПутьВходящихДанных);
	
	Конфигуратор = МенеджерКонфигуратора.УправлениеКонфигуратором();
	
	Если Не ТолстыйКлиент Тогда
		ТонкийКлиент1С = Конфигуратор.ПутьКТонкомуКлиенту1С(Конфигуратор.ПутьКПлатформе1С());
		Конфигуратор.ПутьКПлатформе1С(ТонкийКлиент1С);
	КонецЕсли;

	Конфигуратор.УстановитьПризнакОжиданияВыполненияПрограммы(ОжидатьЗавершения);

	Если Не ЗначениеЗаполнено(РабочийКаталогПроекта) Тогда 
		РабочийКаталогПроекта = "./";
	КонецЕсли;
	РабочийКаталогПроекта = ОбщиеМетоды.ПолныйПуть(РабочийКаталогПроекта);
	
	Если ПустаяСтрока(ПутьКИнструментам) Тогда
		ПутьКИнструментам = add.ПутьИнструментаТДД();
	КонецЕсли;
	
	ФайлСуществует = Новый Файл(ПутьКИнструментам).Существует();
	Ожидаем.Что(ФайлСуществует, СтрШаблон("Ожидаем, что файл <%1> существует, а его нет!", ПутьКИнструментам)).ЭтоИстина();
	
	Если Не ЗагружатьВстроенныеТесты Тогда
		Если Новый Файл(ПутьВходящихДанных).ЭтоКаталог() Тогда
			КлючЗапуска = """xddRun ЗагрузчикКаталога """""+ПутьВходящихДанных+""""";";
		Иначе
			КлючЗапуска = """xddRun ЗагрузчикФайла """""+ПутьВходящихДанных+""""";";
		КонецЕсли;
	Иначе		
		КлючЗапуска = """xddRun ЗагрузчикИзПодсистемКонфигурации """""+ПутьВходящихДанных+""""";";
	КонецЕсли;

	Если Не ПустаяСтрока(ТестКлиент) Тогда
		КлючЗапуска = КлючЗапуска +
				СтрШаблон(" xddTestClient """"%1"""" ; ", ТестКлиент);
	КонецЕсли;
	
	Для каждого ПараметрыОтчета Из ФормируемыеОтчеты Цикл
		Генератор = СтрЗаменить(ПараметрыОтчета.Ключ, "GenerateReport", "ГенераторОтчета");
		КлючЗапуска = КлючЗапуска + "xddReport " + Генератор + " """"" + ПараметрыОтчета.Значение + """"";";
	КонецЦикла;

	Если Не ПустаяСтрока(ПутьККонфигурационномуФайлу) Тогда
		КлючЗапуска = КлючЗапуска + 
				СтрШаблон(" xddConfig """"%1"""" ; ", ПутьККонфигурационномуФайлу);
	КонецЕсли;

	Если Не ПустаяСтрока(ПутьФайлаСтатусаТестирования) Тогда
		КлючЗапуска = КлючЗапуска + 
				СтрШаблон(" xddExitCodePath ГенерацияКодаВозврата """"%1"""" ; ", ПутьФайлаСтатусаТестирования);
	КонецЕсли;

	Настройки = ПрочитатьНастройки(ПутьККонфигурационномуФайлу);

	ПутьЛогаВыполненияСценариев = ПолучитьНастройку(Настройки, "ИмяФайлаЛогВыполненияСценариев", 
								"./build/xddonline.txt", РабочийКаталогПроекта, "путь к лог-файлу выполнения");

	ОбщиеМетоды.УдалитьФайлЕслиОнСуществует(ПутьФайлаСтатусаТестирования);
	ОбщиеМетоды.УдалитьФайлЕслиОнСуществует(ПутьЛогаВыполненияСценариев);

	// КлючЗапуска = КлючЗапуска + " ; debug ";
	КлючЗапуска = КлючЗапуска + " ; workspaceRoot " + РабочийКаталогПроекта;

	КлючЗапуска = КлючЗапуска + " ; xddShutdown;""";

	Лог.Отладка(КлючЗапуска);
	
	ДополнительныеКлючи = " /TESTMANAGER " + ДопПараметры;
	// ДополнительныеКлючи = " /Execute""" + ПутьКИнструментам + """ /TESTMANAGER ";

	Попытка
		МенеджерКонфигуратора.ЗапуститьВРежимеПредприятияСЛогФайлом(
			КлючЗапуска, ПутьКИнструментам, 
			ПутьЛогаВыполненияСценариев,
			ТолстыйКлиент, ДополнительныеКлючи);

		//Проверим итоговый результат работы поведения
		Если Не ПустаяСтрока(ПутьФайлаСтатусаТестирования) Тогда
			Результат = ОбщиеМетоды.ПрочитатьФайлИнформации(ПутьФайлаСтатусаТестирования);
			Если СокрЛП(Результат) <> "0" Тогда
				ВызватьИсключение "Результат работы команды не равен 0 "+ Результат;
			КонецЕсли;
		КонецЕсли;
	Исключение
		Лог.Ошибка(Конфигуратор.ВыводКоманды());
		Лог.Ошибка(ОписаниеОшибки());
		ВызватьИсключение "ЗапуститьТестироватьЮнит";
	КонецПопытки;

	Лог.Информация("Выполнение тестов завершено");
		
КонецПроцедуры // ЗапуститьТестироватьЮнит()

Функция ПараметрыОтчетовXUnit(Знач ПереданныеПараметрыОтчетов, Знач ВыходнойКаталогОтчета = "")
	НаборПараметров = Новый Структура;

	Если Не ПустаяСтрока(ВыходнойКаталогОтчета) Тогда
		НаборПараметров.Вставить("ГенераторОтчетаJUnitXML", ВыходнойКаталогОтчета);
	КонецЕсли;

	Если Не ПустаяСтрока(ПереданныеПараметрыОтчетов) Тогда
		ПараметрыВыводаОтчетов = СтрРазделить(ПереданныеПараметрыОтчетов, ";");
		Для каждого ПараметрВывода Из ПараметрыВыводаОтчетов Цикл
			ПозицияОткрывающейСкобки = СтрНайти(ПараметрВывода, "{");
			ПозицияЗакрывающейСкобки = СтрНайти(ПараметрВывода, "}");
			
			ФорматВывода = СокрЛП(Лев(ПараметрВывода, ПозицияОткрывающейСкобки - 1));
			
			ПереданныйПуть = СокрЛП(Сред(ПараметрВывода, ПозицияОткрывающейСкобки + 1, 
							ПозицияЗакрывающейСкобки - ПозицияОткрывающейСкобки - 1));

			ПутьВывода = ОбщиеМетоды.ПолныйПуть(ПереданныйПуть);

			НаборПараметров.Вставить(ФорматВывода, ПутьВывода);
		КонецЦикла;
	КонецЕсли;
	
	Возврат НаборПараметров;
КонецФункции // ПараметрыОтчетовXUnit()

Процедура ОбеспечитьСуществованиеРодительскихКаталоговДляПутей(Знач НаборПараметров)
	ЕстьОшибка = Ложь;
	СообщениеОшибки = "Генерация отчетов тестирования невозможна, т.к. не существуют каталоги:";
	Для каждого КлючЗначение Из НаборПараметров Цикл
		Путь = КлючЗначение.Значение;
		Файл = Новый Файл(Путь);
		ОбъектКаталог = Новый Файл(Файл.Путь);

		ФС.ОбеспечитьКаталог(ОбъектКаталог.ПолноеИмя);
		
		Если Не ОбъектКаталог.Существует() Тогда
			ЕстьОшибка = Истина;
			СообщениеОшибки = СтрШаблон("%1	%2", СообщениеОшибки, ОбъектКаталог.ПолноеИмя);
		КонецЕсли;
	КонецЦикла;
	Если ЕстьОшибка Тогда
		ВызватьИсключение СообщениеОшибки;
	КонецЕсли;
КонецПроцедуры

// TODO Устранить дублирование с КомандаТестированиеПоведения
Процедура ЗапуститьПроцессВанессы(Знач СтрокаЗапуска, Знач ОжидатьЗавершения, Знач ПутьКФайлуЛога)

	ПериодОпросаВМиллисекундах = 1000;
	
	НадоЧитатьЛог = Истина;
	КолСтрокЛогаПрочитано = 0;

	Процесс = СоздатьПроцесс(СтрокаЗапуска);
	Процесс.Запустить();

	Если ОжидатьЗавершения Тогда

		Приостановить(500);
		// Приостановить(10000);

		Пока НЕ Процесс.Завершен Цикл
			Если ПериодОпросаВМиллисекундах <> 0 Тогда
				Приостановить(ПериодОпросаВМиллисекундах);
			КонецЕсли;

			// ОчереднаяСтрокаВывода = "";
			// ОчереднаяСтрокаОшибок = "";

			// Если Не ПустаяСтрока(ОчереднаяСтрокаВывода) Тогда
			// 	ОчереднаяСтрокаВывода = СтрЗаменить(ОчереднаяСтрокаВывода, Символы.ВК, "");
			// 	Если ОчереднаяСтрокаВывода <> "" Тогда
			// 		Лог.Информация("%2%1", ОчереднаяСтрокаВывода, Символы.ПС);
			// 	КонецЕсли;
			// КонецЕсли;

			// Если Не ПустаяСтрока(ОчереднаяСтрокаОшибок) Тогда
			// 	ОчереднаяСтрокаОшибок = СтрЗаменить(ОчереднаяСтрокаОшибок, Символы.ВК, "");
			// 	Если ОчереднаяСтрокаОшибок <> "" Тогда
			// 		Лог.Ошибка("%2%1", ОчереднаяСтрокаОшибок, Символы.ПС);
			// 	КонецЕсли;
			// КонецЕсли;

			Если НадоЧитатьЛог Тогда
				ВывестиНовыеСообщения(ПутьКФайлуЛога, КолСтрокЛогаПрочитано);
			КонецЕсли;	 
		
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры //ЗапуститьПроцессВанессы

// TODO Устранить дублирование с КомандаТестированиеПоведения
Процедура ВывестиНовыеСообщения(ИмяФайлаЛога, КолСтрокЛогаПрочитано)
	Попытка                     
		МассивСтрок = ПолучитьНовыеСтрокиЛога(ИмяФайлаЛога, КолСтрокЛогаПрочитано);
		Для Каждого Стр Из МассивСтрок Цикл
			Если СокрЛП(Стр) = "" Тогда
				Продолжить;
			КонецЕсли;	 
			Лог.Информация(СокрЛП(Стр));
		КонецЦикла;
	Исключение
		Лог.Ошибка(ОписаниеОшибки());
	КонецПопытки;
		
КонецПроцедуры

// TODO Устранить дублирование с КомандаТестированиеПоведения
Функция ПолучитьНовыеСтрокиЛога(Знач ИмяФайла, КолСтрокЛогаПрочитано)
	Файл = Новый Файл(ИмяФайла);
	Если Не Файл.Существует() Тогда
		Возврат Новый Массив;
	КонецЕсли;	
	
	Текст = Новый ЧтениеТекста;
	Текст.Открыть(ИмяФайла, "UTF-8");
	
	ВесьТекст = Текст.Прочитать();
	
	Текст.Закрыть();
	
	Массив = Новый Массив();
	
	МассивСтрок = СтрРазделить(ВесьТекст, Символы.ПС, Истина);
	Если МассивСтрок[МассивСтрок.Количество() - 1] = "" Тогда
		МассивСтрок.Удалить(МассивСтрок.Количество() - 1);
	КонецЕсли;
	
	Для Ккк = (КолСтрокЛогаПрочитано + 1) По МассивСтрок.Количество() Цикл
		Массив.Добавить(МассивСтрок[Ккк-1]);
	КонецЦикла;	
	
	КолСтрокЛогаПрочитано = МассивСтрок.Количество();
	
	Возврат Массив;
КонецФункции //ПолучитьНовыеСтрокиЛога	

// TODO Устранить дублирование с КомандаТестированиеПоведения
Функция ПрочитатьНастройки(Знач ПутьКНастройкам)
	Рез = Неопределено;

	Если Не ПустаяСтрока(ПутьКНастройкам) Тогда
		Лог.Отладка("Читаю настройки из файла %1", ПутьКНастройкам);

		ФайлНастроек = Новый Файл(ОбщиеМетоды.ПолныйПуть(ПутьКНастройкам));
		СообщениеОшибки = СтрШаблон("Ожидали, что файл настроек %1 существует, а его нет.");
		Ожидаем.Что(ФайлНастроек.Существует(), СообщениеОшибки).ЭтоИстина();

		ЧтениеТекста = Новый ЧтениеТекста(ФайлНастроек.ПолноеИмя, КодировкаТекста.UTF8);
		
		СтрокаJSON = ЧтениеТекста.Прочитать();
		ЧтениеТекста.Закрыть();

		ПарсерJSON = Новый ПарсерJSON();
		Рез = ПарсерJSON.ПрочитатьJSON(СтрокаJSON);
		
		Лог.Отладка("Успешно прочитали настройки");
		Лог.Отладка("Настройки из файла:");
		Для каждого КлючЗначение Из Рез Цикл
			Лог.Отладка("	%1 = %2", КлючЗначение.Ключ, КлючЗначение.Значение);
		КонецЦикла;
	Иначе
		Лог.Отладка("Файл настроек не передан. Использую значение по умолчанию.");
	КонецЕсли;
	Возврат Рез;
КонецФункции

// TODO Устранить дублирование с КомандаТестированиеПоведения
Функция ПолучитьНастройку(Знач Настройки, Знач ИмяНастройки, Знач ЗначениеПоУмолчанию, 
		Знач РабочийКаталогПроекта, Знач ОписаниеНастройки, Знач ПолучатьПолныйПуть = Истина)

	Рез = ЗначениеПоУмолчанию;
	Если Настройки <> Неопределено Тогда
		Рез_Врем = Настройки.Получить(ИмяНастройки);
		Если Рез_Врем <> Неопределено Тогда
			Лог.Отладка("	Ключ %1, Значение %2", ИмяНастройки, Рез_Врем);

			Рез = Заменить_workspaceRoot_на_РабочийКаталогПроекта(Рез_Врем, РабочийКаталогПроекта);

			Лог.Отладка("В настройках нашли %1 %2", ОписаниеНастройки, Рез);
		КонецЕсли;
	КонецЕсли;
	Лог.Отладка("Использую %1 %2", ОписаниеНастройки, Рез);
	
	Если ПолучатьПолныйПуть Тогда
		Рез = ОбщиеМетоды.ПолныйПуть(Рез);
		Лог.Отладка("Использую %1 (полный путь) %2", ОписаниеНастройки, Рез);
	КонецЕсли;
	Возврат Рез;
КонецФункции

// TODO Устранить дублирование с КомандаТестированиеПоведения
Функция Заменить_workspaceRoot_на_РабочийКаталогПроекта(Знач ИсходнаяСтрока, Знач РабочийКаталогПроекта)
	Возврат СтрЗаменить(ИсходнаяСтрока, "$workspaceRoot", РабочийКаталогПроекта);
КонецФункции

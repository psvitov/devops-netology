# Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."

## Задача 1. 
Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда: 
[https://github.com/hashicorp/terraform-provider-aws.git](https://github.com/hashicorp/terraform-provider-aws.git).
Просто найдите нужные ресурсы в исходном коде и ответы на вопросы станут понятны.  


1. Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на 
гитхабе.   
2. Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`. 
    * С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано.
    * Какая максимальная длина имени? 
    * Какому регулярному выражению должно подчиняться имя? 

---
### Ответ:
---
#### Пункт 1:


1. Клонируем исходный код:

> 
    root@DevOps:~/Homeworks/hw76# git clone https://github.com/hashicorp/terraform-provider-aws.git
    
2. Согласно структуре провайдера доступные ресурсы и источники данных задаются в файле `provider.go` (презентация - стр. 17)
3. Ищем файл `provider.go`:

>
     root@DevOps:~/Homeworks/hw76/terraform-provider-aws# find -name provider.go
     ./tools/providerlint/vendor/github.com/hashicorp/terraform-plugin-go/tfprotov5/provider.go
     ./tools/providerlint/vendor/github.com/hashicorp/terraform-plugin-go/tfprotov5/internal/fromproto/provider.go
     ./tools/providerlint/vendor/github.com/hashicorp/terraform-plugin-go/tfprotov5/internal/toproto/provider.go
     ./tools/providerlint/vendor/github.com/hashicorp/terraform-plugin-go/tfprotov6/provider.go
     ./tools/providerlint/vendor/github.com/hashicorp/terraform-plugin-go/tfprotov6/internal/fromproto/provider.go
     ./tools/providerlint/vendor/github.com/hashicorp/terraform-plugin-go/tfprotov6/internal/toproto/provider.go
     ./tools/providerlint/vendor/github.com/hashicorp/terraform-plugin-go/internal/logging/provider.go
     ./tools/providerlint/vendor/github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema/provider.go
     ./tools/providerlint/vendor/github.com/hashicorp/terraform-registry-address/provider.go
     ./tools/providerlint/vendor/github.com/hashicorp/terraform-plugin-log/tflog/provider.go
     ./tools/providerlint/vendor/github.com/hashicorp/terraform-plugin-log/internal/logging/provider.go
     ./internal/provider/fwprovider/provider.go
     ./internal/provider/provider.go

4. Анализ данных показал, что данные хранятся в файле `./internal/provider/provider.go`
5. Ссылка на [`resource`](https://github.com/hashicorp/terraform-provider-aws/blob/c67e927dfe8c8d5614bcb78eaddd696d06830528/internal/provider/provider.go#L913)
6. Ссылка на [`data_source`](https://github.com/hashicorp/terraform-provider-aws/blob/c67e927dfe8c8d5614bcb78eaddd696d06830528/internal/provider/provider.go#L415)

#### Пункт 2:

1. Согласно [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) параметр `name` конфликтует с `name_prefix`

Поиск файлов:

> 
    root@DevOps:~/Homeworks/hw76/terraform-provider-aws# find -name queue.go
    ./internal/service/connect/queue.go
    ./internal/service/sqs/queue.go
    ./internal/service/mediaconvert/queue.go

Анализ файла `./internal/service/sqs/queue.go`:

> 
    root@DevOps:~/Homeworks/hw76/terraform-provider-aws# grep -r -n "name_prefix" ./internal/service/sqs/queue.go
    87:ConflictsWith: []string{"name_prefix"},
    89:"name_prefix": {
    195:name = create.NameWithSuffix(d.Get("name").(string), d.Get("name_prefix").(string), FIFOQueueNameSuffix)
    197:name = create.Name(d.Get("name").(string), d.Get("name_prefix").(string))
    301:d.Set("name_prefix", create.NamePrefixFromNameWithSuffix(name, FIFOQueueNameSuffix))
    303:d.Set("name_prefix", create.NamePrefixFromName(name))
    417:name = create.NameWithSuffix(diff.Get("name").(string), diff.Get("name_prefix").(string), FIFOQueueNameSuffix)
    419:name = create.Name(diff.Get("name").(string), diff.Get("name_prefix").(string))

Ссылка на [строку кода](https://github.com/hashicorp/terraform-provider-aws/blob/c67e927dfe8c8d5614bcb78eaddd696d06830528/internal/service/sqs/queue.go#L82)

Согласно [FAQ AWS](https://aws.amazon.com/ru/sqs/faqs/) длина имени ограничена 80 символами

Поиск строки кода:

> 
    grep -r -n " 80 "
    
    ...
    
    internal/service/sfn/validate.go:10:	if len(value) > 80 {
    internal/service/sfn/validate.go:11:		errors = append(errors, fmt.Errorf("%q cannot be longer than 80 characters", k))

Ссылка на [строку кода](https://github.com/hashicorp/terraform-provider-aws/blob/c67e927dfe8c8d5614bcb78eaddd696d06830528/internal/service/sfn/validate.go#L10)

Анализ файла так же показал, что регулярное выражение, которому должно подчиняться имя, может использовать прописные и строчные буквы, цифры и спецсимвол `_`

Ссылка на [строку кода](https://github.com/hashicorp/terraform-provider-aws/blob/c67e927dfe8c8d5614bcb78eaddd696d06830528/internal/service/sfn/validate.go#L14) 

---

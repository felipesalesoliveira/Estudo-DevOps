# *SEQUÊNCIA TERRAFORM*

1. Providers.tf
    1.1. AWS: (Criar credenciais no IAM)
2. Bucket.tf (aws) ou Storage_account.tf (azure)
3. tf providers
4. tf init
5. tf fmt -check
6. tf check
7. tf validate
8. Variables.tf
9. Locals.tf
10. Outputs.tf
11. colar credenciais (em caso de AWS)
12. tf plan -out plan.out
13. tf apply
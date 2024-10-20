# Nesse caso a ideia é, você já alterou seu bucket para usar outra classe de storage mas em algum momento a interface console caiu
# ou haviam muitos objetos e você não tinha como ficar esperando,,, ou qualquer outro motivo, mas agora você precisa saber se todos estão 
# na classe que deveriam estar.

# substitua o nome-do-seu-bucket pelo nome do bucket que você quer ver

# primeiro vamos ao básico, listar objetos no bucket
aws s3api list-objects-v2 --bucket nome-do-seu-bucket

# agora vamos listar os objetos do bucket que estão em uma classe de storage específica 
aws s3api list-objects-v2 --bucket nome-do-seu-bucket --query "Contents[?StorageClass=='GLACIER']"

# a mesma coisa do comando acima mas com uma saida mais elegante
aws s3api list-objects-v2 --bucket nome-do-seu-bucket --query "Contents[].{Key:Key,Size:Size,StorageClass:StorageClass}" --output table

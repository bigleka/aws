#!/bin/bash

# Caso você tenha feito a troca de classe de storage de muitos arquivos pela console web da AWS
# mas por algum motivo alguns arquivos ficaram em outra classe, esse script vai tentar localizar
# esses arquivos de uma classe X e trocar para a classe Y
# coloque o bucket name no nome do seu bucket e de qual classe que está para a classe que você quer.
# o script ainda não é perfeito, ele pode apresentar erros na tentativa de conversão do storage, 
# no caso de erro tente entender a mensagem de erro, qualquer coisa, use o scrip anterior para achar
# quem ficou na classe diferente e faça a troca manual.

BUCKET_NAME="XXXXXXXXXXXXXXXX"
SOURCE_STORAGE_CLASS="STANDARD"
TARGET_STORAGE_CLASS="GLACIER"

echo "Starting storage class change process for bucket: $BUCKET_NAME"
echo "Changing from $SOURCE_STORAGE_CLASS to $TARGET_STORAGE_CLASS"

aws s3api list-objects-v2 --bucket $BUCKET_NAME --query "Contents[?StorageClass=='$SOURCE_STORAGE_CLASS'].Key" --output text | while read -r key; do
    echo "Processing object: $key"

    echo "Changing storage class for: $key"
    aws s3api copy-object --bucket $BUCKET_NAME --copy-source $BUCKET_NAME/"$key" --key "$key" --storage-class $TARGET_STORAGE_CLASS --output json

    if [ $? -eq 0 ]; then
        echo "Sucesso, substituido a classe de storage do objeto: $key"
    else
        echo "Falha na substituicao da classe de storage do objeto: $key"
    fi

    echo "----------------------------------------"
done

echo "Troca de classe de storage finalizada."


# Bonus, caso precise trocar a classe de armazenamente de um objeto específico, você pode fazer o seguinte:
#aws s3api copy-object --bucket nome-do-seu-bucket --copy-source nome-do-seu-bucket/chave-do-objeto --key chave-do-objeto --storage-class STANDARD_IA

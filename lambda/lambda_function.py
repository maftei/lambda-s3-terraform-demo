import boto3

def lambda_handler(event, context):
    s3 = boto3.client("s3")

    bucket_name = event["bucket"]
    file_key = event["key"]

    response = s3.get_object(Bucket=bucket_name, Key=file_key)
    content = response["Body"].read().decode("utf-8")

    print("File content:")
    print(content)

    return {
        "statusCode": 200,
        "body": content
    }

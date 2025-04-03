import os
import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ.get('DYNAMODB_TABLE', 'my-default-table'))

def lambda_handler(event, context):
    """
    Exemple d'endpoint GET /hello?name=Alice
    """
    query_params = event.get("queryStringParameters") or {}
    name = query_params.get("name", "Unknown")

    # Stockage dans DynamoDB
    table.put_item(
        Item={
            "PK": name,
            "message": f"Hello {name}!"
        }
    )

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "success": True,
            "message": f"Hello {name}!"
        })
    }


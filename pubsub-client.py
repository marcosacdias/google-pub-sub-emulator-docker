import json
import os
import subprocess
import sys

path_sub_python = r"/python-pubsub/samples/snippets"
gcloud_project = os.getenv("PUBSUB_PROJECT_ID", "my-gcp-project")

os.environ["PUBSUB_EMULATOR_HOST"] = "localhost:8085"

def create_topics_and_subscriptions(project_id, json_config):
    try:
        pubsub_config = json.loads(json_config)

        for topic in pubsub_config:
            create_topic(project_id, topic["name"])
            if "subscriptions" in topic:
                for subscription in topic["subscriptions"]:
                    create_subscription(project_id, topic["name"], subscription)

    except:
        print("Failed to parse JSON Pub/Sub configuration, please verify the input:")
        print(sys.argv[2])
        raise


def create_topic(project_id, topic_id):
    print(f'>> creating topic {topic_id}')
    command = ["python3", os.path.join(
        path_sub_python, "publisher.py"), project_id, "create", topic_id]

    output, error = execute_command(command)

    if error and b'ERROR' in error:
        print(
            f'<< error while creating topic [{topic_id}]: {error}')
        exit()

    print(f'<< topic {topic_id} created successfully')


def create_subscription(project_id, topic_id, subscription_id):
    print(f'>> creating subscription {subscription_id}')

    command = ["python3", os.path.join(
        path_sub_python, "subscriber.py"), gcloud_project, "create", topic_id, subscription_id]

    output, error = execute_command(command)
    if error and b'ERROR' in error:
        print(
            f'<< error while creating subscription [{subscription_id}]: {error}')
        exit()

    print(f'<< subscription {subscription_id} created successfully')

def execute_command(command):
    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output, error = process.communicate()
    return output, error


if __name__ == "__main__":
    print(f'>> Start command arg {sys.argv[1]}')
    if sys.argv[1] == "create":
        create_topics_and_subscriptions(sys.argv[2], sys.argv[3])
    else:
        print("Unknown command {}".format(sys.argv[1]))

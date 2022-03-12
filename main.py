from gettext import install
import json
import profile
import boto3
# from numpy import size


def main():
    pass


cluster = 'zenith-apps-cluster-stg'
debug = False

def get_instances_id():
    """
      explicacion
    """
    ec2 = []
    try:
        ecs_client = boto3.client('ecs')
        ec2 = ecs_client.list_container_instances(
            cluster=cluster
        )
        ci_descriptions_response = ecs_client.describe_container_instances(
            cluster=cluster,
            containerInstances=[
                'arn:aws:ecs:us-west-2:558102088346:container-instance/zenith-apps-cluster-stg/6c4a60d0ee6743499361ac109b1bf907']
        )
    except:
        print("error")

    return ec2['containerInstanceArns']


def get_instance_info(arn=""):
    ec2 = boto3.resource('ec2')
    i = ec2.instances.filter
    running_instances = ec2.instances.filter(Filters=[{
        'Arn': arn}])


def instance_id(client, cluster, instance_arn=""):
    instances_ids = []
    ec2_json = client.list_container_instances(
        cluster=cluster
    )
    ci = client.describe_container_instances(
        cluster=cluster,
        containerInstances=[instance_arn]
    )

    for ec2_data in ci['containerInstances']:
        instance_id.append(ec2_data['ec2InstanceId'])

        if debug: print(ec2_data['ec2InstanceId'])

    return instances_ids

def ecs_info(client, instance_id=""):
    pass

if __name__ == '__main__':
    boto3.setup_default_session(
        region_name="us-west-2",
        profile_name="console"
    )

# 'arn:aws:ecs:us-west-2:558102088346:container-instance/zenith-apps-cluster-stg/6c4a60d0ee6743499361ac109b1bf907'

    ecs_client = boto3.client('ecs')
    # ec2 = ecs_client.list_container_instances(
    #     cluster=cluster
    # )
    # ci = ecs_client.describe_container_instances(
    #     cluster=cluster,
    #     containerInstances=[
    #         'arn:aws:ecs:us-west-2:558102088346:container-instance/zenith-apps-cluster-stg/6c4a60d0ee6743499361ac109b1bf907'
    #     ]
    # )
    instance_id(ecs_client,
                cluster,
                'arn:aws:ecs:us-west-2:558102088346:container-instance/zenith-apps-cluster-stg/6c4a60d0ee6743499361ac109b1bf907')

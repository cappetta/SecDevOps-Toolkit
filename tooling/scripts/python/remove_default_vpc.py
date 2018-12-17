import boto3
import traceback


class Delete_Default_VPC(object):
    def __init__(self):
        self.service_type = ‘ec2’
        self.zone_name = ‘ < provide
        the
        region > (ex:us - east - 1)’
        # You can provide any region. This is just for establishing the connection. All   other regions will be selected automatically by the script.
        # todo: create secdevops inspect rule - access key check, hard-coding
        self.access_key = ‘XXXXXXXX’
        self.secret_key = ‘XXXXXXXXXXXX’
        self.ec2_conn_client = boto3.client(self.service_type, self.zone_name, aws_access_key_id=self.access_key,
                                            aws_secret_access_key=self.secret_key)
        self.ec2_conn_resource = boto3.resource(self.service_type, self.zone_name, aws_access_key_id=self.access_key,
                                                aws_secret_access_key=self.secret_key)

    # call describe_regions to delete VPCs
    def describe_regions(self):
        method_name = {‘method_name’: ‘describe_regions’}
        try:
            region_list = []
            response = self.ec2_conn_client.describe_regions()
            for data in response[“Regions”]:
                region_list.append(data[“RegionName”])
                for data in region_list:
                    print data
                    self.region_connect = boto3.client(self.service_type, data, aws_access_key_id=self.access_key,
                                                       aws_secret_access_key=self.secret_key)
                    delete_vpc = self.delete_vpcs()
                    print delete_vpc

            except:
            status_message = “Execution
            failed
            while describing regions.” + str(traceback.format_exc())
            print status_message

    def delete_vpcs(self):
        method_name = {‘method_name’: ‘describe_vpcs’}
        try:
            response = self.region_connect.describe_vpcs()
            for vpc in response[“Vpcs”]:
                if vpc[“IsDefault”] == True:
                    subnet_ids = self.describe_subnets(vpc[“VpcId”])
                    delete_subnets = self.delete_subnets(subnet_ids)
                    igw_ids = self.describe_igw(vpc[“VpcId”])
                    detach_igw = self.detach_igw(vpc[“VpcId”], igw_ids)
                    delete_igw = self.delete_igw(igw_ids)
                    response = self.region_connect.delete_vpc(
                        DryRun=False,
                        VpcId=vpc[“VpcId”]
                    )
                    return (“Default
                    VPC is deleted”)

                    except:
                    status_message = “Execution
                    failed
                    while deleting vpc.” + str(traceback.format_exc())
                    print status_message

            def detach_igw(self, vpc, igw):
                method_name = {‘method_name’: ‘detach_igw’}
                try:
                    igw_list = igw
                    vpc_id = vpc
                    for id in igw_list:
                        response = self.region_connect.detach_internet_gateway(
                            DryRun=False,
                            InternetGatewayId=id,
                            VpcId=vpc_id
                        )

                except:
                    status_message = “Execution
                    failed
                    while detaching igw.” + str(traceback.format_exc())
                    print status_message

            def describe_igw(self, vpcid):
                method_name = {‘method_name’: ‘describe_igw’}
                try:
                    igw_list = []
                    vpc_id = vpcid
                    describe_response = self.region_connect.describe_internet_gateways(
                        DryRun=False,
                        Filters=[
                            {
                    ‘Name’: ‘attachment.vpc - id’,
                    ‘Values’: [
                        vpc_id,
                    ]
                    },
                    ]
                    )
                    for ids in describe_response[“InternetGateways”]:
                        igw_list.append(ids[“InternetGatewayId”])
                        return igw_list

                    except:
                    status_message = “Execution
                    failed
                    while describing igw.” + str(traceback.format_exc())
                    print status_message

            def delete_igw(self, igwid):
                method_name = {‘method_name’: ‘delete_igw’}
                try:
                    igw_list = igwid
                    for id in igw_list:
                        delete_response = self.region_connect.delete_internet_gateway(
                            DryRun=False,
                            InternetGatewayId=id
                        )

                except:
                    status_message = “Execution
                    failed
                    while deleting igw.” + str(traceback.format_exc())
                    print status_message

            def describe_sec_grp(self, vpcid):
                method_name = {‘method_name’: ‘describe_sec_grp’}
                try:
                    sg_list = []
                    vpc_id = vpcid
                    describe_response = self.region_connect.describe_security_groups(
                        DryRun=False,
                        Filters=[
                            {
                    ‘Name’: ‘vpc - id’,
                    ‘Values’: [
                        vpc_id,
                    ]
                    },
                    ]
                    )
                    for ids in describe_response[“SecurityGroups”]:
                        sg_list.append(ids[“GroupId”])
                        return sg_list

                    except:
                    status_message = “Execution
                    failed
                    while describing sec grp.” + str(traceback.format_exc())
                    print status_message

            def delete_sec_grp(self, sgid):
                method_name = {‘method_name’: ‘delete_sec_grp’}
                try:
                    sg_list = sgid
                    for id in sg_list:
                        delete_response = self.region_connect.delete_security_group(
                            DryRun=False,
                            # GroupName=’string’,
                            GroupId=id
                        )

                except:
                    status_message = “Execution
                    failed
                    while deleting sec grp.” + str(traceback.format_exc())
                    print status_message

            def describe_subnets(self, vpcid):
                method_name = {‘method_name’: ‘describe_subnets’}
                try:
                    subnet_list = []
                    vpc_id = vpcid
                    describe_response = self.region_connect.describe_subnets(
                        DryRun=False,
                        Filters=[
                            {
                    ‘Name’: ‘vpc - id’,
                    ‘Values’: [
                        vpc_id,
                    ]
                    },
                    ]
                    )
                    for ids in describe_response[“Subnets”]:
                        subnet_list.append(ids[“SubnetId”])
                        return subnet_list

                    except:
                    status_message = “Execution
                    failed
                    while describing subnets.” + str(traceback.format_exc())
                    print status_message

            def delete_subnets(self, subnetid):
                method_name = {‘method_name’: ‘delete_subnets’}
                try:
                    subnet_id_list = subnetid
                    for id in subnet_id_list:
                        delete_response = self.region_connect.delete_subnet(
                            DryRun=False,
                            SubnetId=id
                        )

                        # return delete_response
                except:
                    status_message = “Execution
                    failed
                    while deleting subnets.” + str(traceback.format_exc())
                    print status_message

            def delete_route_table(self, routeid):
                method_name = {‘method_name’: ‘delete_route_table’}
                try:
                    route_id = routeid
                    delete_route_table_response = self.region_connect.delete_route_table(
                        DryRun=False,
                        RouteTableId=route_id
                    )
                except:
                    status_message = “Execution
                    failed
                    while deleting route_table.” + str(traceback.format_exc())
                    print status_message

        if __name__ ==’__main__’:
            launcher = Delete_Default_VPC()
            launcher.describe_regions()

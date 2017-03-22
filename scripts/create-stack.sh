#!/bin/bash

# creates a stack in AWS via CloudFromation

STACKNAME=${1:-Weapon-X-RDS}
SUBNETS=${2:-subnet-014ffa48,subnet-47158620}
VPC=${3:-vpc-fadca69d}
PROJECTNAME=${4:-Weapon-X}
ENGINE_VERSION=${5:-5.5.46}
ENGINE_OPTION_FAMILY=${6:-MySQL5.5}
ENVIRONMENT=${7:-development}
CREATOR=${8:-CloudFormation}
PURPOSE=${9:-Testing}
TEMPLATELOCATION=${10:-file://$(pwd)/rds.yml}

VALIDATE="aws cloudformation validate-template --template-body $TEMPLATELOCATION"
echo $VALIDATE
$VALIDATE

CREATE="aws cloudformation create-stack --stack-name $STACKNAME \
                                        --disable-rollback \
                                        --template-body $TEMPLATELOCATION \
                                        --capabilities CAPABILITY_NAMED_IAM \
                                        --parameters ParameterKey=Project,ParameterValue=$PROJECTNAME \
                                                     ParameterKey=Environment,ParameterValue=$ENVIRONMENT \
                                                     ParameterKey=VPC,ParameterValue=$VPC \
                                                     ParameterKey=Creator,ParameterValue=$CREATOR \
                                                     ParameterKey=EngineVersion,ParameterValue=$ENGINE_VERSION \
                                                     ParameterKey=EngineOptionFamily,ParameterValue=$ENGINE_OPTION_FAMILY \
                                                     ParameterKey=Subnets,ParameterValue=\"$SUBNETS\" \
                                        --tags Key=Project,Value=$PROJECTNAME \
                                               Key=Purpose,Value=$PURPOSE \
                                               Key=Environment,Value=$ENVIRONMENT \
                                               Key=Creator,Value=$CREATOR"
echo $CREATE
$CREATE

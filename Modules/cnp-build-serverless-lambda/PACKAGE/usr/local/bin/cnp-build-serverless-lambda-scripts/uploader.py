#! /usr/bin/python3

import file_utils
import pip_utils
import os
import shutil
import sys
import json
import logging
import re


logging.basicConfig(format='%(asctime)s - %(levelname)s - %(funcName)s - %(message)s', datefmt='%Y-%m-%d %H:%M:%S')

log_level = os.getenv('CNP_LOG_LEVEL').upper()

if log_level in ['DEBUG', 'INFO', 'WARN', 'ERROR', 'CRITICAL']:
    logging.getLogger().setLevel(log_level)
elif log_level == 'TRACE':
    logging.getLogger().setLevel(logging.DEBUG)
else:
    logging.getLogger().setLevel(logging.INFO)

def parse_args():
    args=json.loads(sys.argv[1])
    return args


def main():

    args = parse_args()

    try:
        repo_url = args['repoUrl']
        commit_id = args['commitId']
        # appName = args['appName']
        # af_archive_path = args['artifactoryArchivePath']
        lambda_language = args['lambdaLanguage'].lower()
        branch = args['branchName']
        lambda_name = re.search('.*.git.express-scripts.com/.*/(.*).git', repo_url).group(1)

        files_to_remove = None
        dirs_to_remove = None
        try:
            files_to_remove = args['filesToRemoveFromZip']
            dirs_to_remove = args['directoriesToRemoveFromZip']
            logging.debug('lambda_language : ' + filesToRemoveFromZip)
            logging.debug('commit_id : ' + directoriesToRemoveFromZip)
        except:
            pass

        logging.debug('lambda_language : ' + lambda_language)
        logging.debug('commit_id : ' + commit_id)
        logging.debug('Repo: ' + repo_url)
        # logging.debug('App Name: ' + appName)
        logging.debug('Branch: ' + branch)
        logging.debug('Lmabda Name: ' + lambda_name)

    except IndexError as e:
        logging.exception('Required parameters are missing')
        logging.exception('Required parameters in Jenkinsfile: lambdaLanguage')
        # logging.exception('Required parameters in Jenkinsfile: artifactoryArchivePath, lambdaLanguage')
        exit(1)

    # if lambda_language == 'java':
    #     for lambda_name in lambda_folder_names:
    #         file_name, file_path = java_utils.compile_mvn(lambda_name, git_path, git_lambda_root)
    #         s3_utils.upload_to_s3(file_name, file_path, bucket)
    #         file_utils.upload_to_artifactory(file_name, file_path, af_archive_path, lambda_name)


    git_path = os.getcwd()
    logging.debug('Git Path: ' + git_path)

    logging.info('----------------PIP----------------')
    pip_utils.download_dependencies(git_path)
    logging.info('----------------ZIP----------------')
    zip_file_path = file_utils.zip_lambda(git_path, files_to_remove, dirs_to_remove)
    # logging.info('----------------ARTIFACTORY----------------')
    # file_utils.upload_to_artifactory(zip_file_name, zip_file_path, af_archive_path, appName)


if __name__ == "__main__":
    main()


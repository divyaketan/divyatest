#! /usr/bin/python3

import os
import zipfile
from time import sleep
import requests
from datetime import datetime
import logging
import shutil
import re

def get_all_file_paths(directory):
    file_paths = []

    for root, directories, files in os.walk(directory):

        for filename in files:
            filepath = os.path.join(root, filename)
            file_paths.append(filepath)

    return file_paths

def get_all_dir_paths(directory):
    dir_paths = []

    for root, directories, files in os.walk(directory):
        dir_paths.append(root)

    return dir_paths

def zip_lambda(git_path, files_to_remove=None, dirs_to_remove=None):

    zip_file_name = 'lambda.zip'
    temp_zip_path = '/tmp/temp_zip/'
    terraform_path = git_path + '/terraform/'
    zip_file_path = terraform_path + zip_file_name
    
    # set up temp zip path
    if os.path.isdir(temp_zip_path):
        shutil.rmtree(temp_zip_path)
    tmp_file_path = shutil.copytree(git_path, temp_zip_path)

    try:
        logging.debug('Removing the following "dist-info" folders leftover from pip install:')
        for dirs in get_all_dir_paths(temp_zip_path):
            if re.match('.*dist-info$', dirs):
                logging.debug(dirs)
                shutil.rmtree(dirs , True)

        if (files_to_remove):
            for files in files_to_remove.split(';'):
                try:
                    os.remove(temp_zip_path + files)
                except:
                    pass

        if (dirs_to_remove):
            for dirs in dirs_to_remove.split(';'):
                shutil.rmtree(temp_zip_path + dirs , True)
        print('=========================================')

    except:
        logging.exception('File removal from zip failed')
        pass

    logging.debug('Following files will be zipped:')
    for files in get_all_file_paths(tmp_file_path):
        logging.debug(files)

    try:
        zip_file = shutil.make_archive(base_name =  '/tmp/zip_out',
                            format    =  'zip',
                            root_dir  =  tmp_file_path,
                                )

        shutil.move(zip_file, terraform_path + zip_file_name)

    except Exception as e:
        logging.exception('Zip creation failed.')
        exit(1)

    logging.info('=====Zip file created successfully=====')
    logging.debug('Following files are in terraform dir:')
    for files in get_all_file_paths(terraform_path):
        logging.debug(files)

    return zip_file_path + '.zip'


#TODO remove lambda_name and replace with repo name
def upload_to_artifactory(file_name, file_path, af_archive_path, lambda_name):
    af_user = os.environ['CNP_BUILD_SERVERLESS_LAMBDA_ARTIFACTORY_MODULE_USER']
    af_cred = os.environ['CNP_BUILD_SERVERLESS_LAMBDA_ARTIFACTORY_CRED']
    af_root_url = os.environ['ARTIFACTORY_ROOT_URL']

    logging.info('Starting Artifactory upload')
    full_url = af_root_url + '/' + af_archive_path + '/' + lambda_name + '/' + datetime.today().strftime('%Y-%m-%d') + '/' + file_name
    try:
        with open(file_path, 'rb') as f:
            data = f.read()
            logging.info('Uploading file ' + file_name + ' to ' + full_url)
            headers = headers = {'Content-type': 'application/binary'}
            response = requests.put(full_url, auth=(af_user, af_cred), data=data, headers=headers)
    except Exception as e:
        logging.exception('Error uploading zip bundle to Artifactory')
        exit(1)

    logging.info(response.text)

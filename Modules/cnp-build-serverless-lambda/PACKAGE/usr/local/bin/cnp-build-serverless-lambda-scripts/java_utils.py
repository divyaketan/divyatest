#! /usr/bin/python3

import os
import shutil
import subprocess
import logging
import xml.etree.ElementTree as ET


def compile_mvn(lambda_name, git_path, git_lambda_root):
    folder_path = git_path + git_lambda_root + lambda_name
    os.chdir(folder_path)

    root = ET.parse(folder_path + '/pom.xml').getroot()

    artifactId = root.find('./' + root.tag[:root.tag.index('}') +1] + 'artifactId').text
    version = root.find('./' + root.tag[:root.tag.index('}') +1] + 'version').text

    jar_name = artifactId + '-' + version

    mvn = subprocess.Popen('mvn package -Djar.finalName=' + jar_name, shell=True, encoding='utf-8', stdout=subprocess.PIPE,stderr=subprocess.PIPE)

    while True:
        live_output = mvn.stdout.readline()
        if live_output == '' and mvn.poll() is not None:
            break
        if live_output:
            print(live_output.strip(), flush=True)

    output, error = mvn.communicate()
    if (output):
        logging.info(output)
    if (error):
        logging.error(error)
        exit(1)

    jar_name = jar_name + '.jar'
    jar_path_full = git_path + git_lambda_root + lambda_name + '/target/' + jar_name # + '.jar'

    return jar_name, jar_path_full



import os
import subprocess
from dotenv import load_dotenv

load_dotenv()

repository_url = 'https://github.com/kubecost/docs.git'
target_directory = os.environ.get('SOURCE_DIRECTORY', 'source_documents')

if os.path.exists(target_directory):
    print(f"Directory '{target_directory}' already exists. Performing git pull instead.")
    subprocess.run(['cd', target_directory], shell=True)
    subprocess.run(['git', 'pull'], cwd=target_directory)
else:
    subprocess.run(['git', 'clone', '-q', repository_url, target_directory])

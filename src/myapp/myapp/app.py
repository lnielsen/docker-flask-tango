from os import environ
from os.path import join

from flask import Flask, render_template
from flask_webpackext import FlaskWebpackExt
from flask_webpackext.project import WebpackTemplateProject
from pywebpack import LinkStorage

home_path = environ['HOME']

# Application
app = Flask(
    __name__,
    instance_path=join(home_path, 'instance'),
    template_folder=join(home_path, 'templates'),
    static_folder=join(home_path, 'instance/static'),
    instance_relative_config=True,
)

project = WebpackTemplateProject(
    __name__,
    project_folder='assets',
    config_path='config.json',
)

# Config
app.config.update({
    'WEBPACKEXT_PROJECT': project,
    'WEBPACKEXT_STORAGE_CLS': LinkStorage,
})
app.config.from_pyfile('app.cfg')

# Extensions
FlaskWebpackExt(app)

# Views
@app.route('/')
def hello_world():
    return render_template('index.html', title="Hello, World!")

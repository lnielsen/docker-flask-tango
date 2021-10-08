FROM registry.access.redhat.com/ubi8/python-39
EXPOSE 5000

ENV NODEJS_VER=14 \
    INSTALL_PACKAGES="cairo-devel epel-release" \
    EPEL_INSTALL_PACKAGES=ImageMagick

# Install extra packages
# - Enables Cent OS 8 repositories at CERN
# - Enables EPEL repository (needed for ImageMagick and XRootD)
USER root
RUN dnf --disableplugin=subscription-manager install -y http://linuxsoft.cern.ch/cern/centos/s8/CERN/x86_64/Packages/centos-gpg-keys-8-2.2.el8s.cern.noarch.rpm http://linuxsoft.cern.ch/cern/centos/s8/CERN/x86_64/Packages/centos-linux-repos-8-2.2.el8s.cern.noarch.rpm \
 && dnf --disableplugin=subscription-manager install -y ${INSTALL_PACKAGES} \
 && dnf --disableplugin=subscription-manager install -y ${EPEL_INSTALL_PACKAGES} \
 && dnf --disableplugin=subscription-manager clean all
USER 1001

# Create instance directory
# ENV INVENIO_INSTANCE_PATH=${APP_ROOT}/var/instance
#RUN mkdir -p ${INVENIO_INSTANCE_PATH} \
#    mkdir ${INVENIO_INSTANCE_PATH}/data \
#    mkdir ${INVENIO_INSTANCE_PATH}/archive \
#    mkdir ${INVENIO_INSTANCE_PATH}/static

# Install requirements
COPY requirements.txt /opt/app-root/
RUN pip install "pip==21.2.4" \
    && pip install -r /opt/app-root/requirements.txt

ENV FLASK_APP=myapp.app:app \
    FLASK_ENV=development

### ---SITE IMAGE---

# Install extra modules
WORKDIR ${HOME}
COPY --chown=1001:root . .

RUN pip install -e src/myapp

# TODO symlink assets (always?) when building in compose when module is mounted
# Run flask collect?
RUN flask webpack create \
    && flask webpack install \
    && flask webpack build

CMD ["flask", "run", "-h", "0.0.0.0"]

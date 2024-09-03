# base image
FROM python:3.11-slim

# work dirs
RUN mkdir /app
RUN mkdir /app/deepface
WORKDIR /app

# pre-download gender model weights
ADD https://github.com/serengil/deepface_models/releases/download/v1.0/gender_model_weights.h5 /root/.deepface/weights/gender_model_weights.h5

# update image os
RUN apt-get update
RUN apt-get install -qy gcc libc-dev libffi-dev libxext6 libhdf5-dev libsm6 ffmpeg pkg-config

# Copy required files from repo into image
COPY ./deepface /app/deepface
COPY ./requirements.txt /app/requirements.txt
COPY ./package_info.json /app/
COPY ./setup.py /app/
COPY ./README.md /app/

# if you plan to use a GPU, you should install the 'tensorflow-gpu' package
# RUN pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host=files.pythonhosted.org tensorflow-gpu

# install deepface from source code (always up-to-date)
RUN --mount=type=cache,target=/root/.cache/pip,sharing=locked \
  pip install --upgrade pip && \
  pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host=files.pythonhosted.org -e .

# environment variables
ENV PYTHONUNBUFFERED=1

# run the app (re-configure port if necessary)
WORKDIR /app/deepface/api/src
EXPOSE 5000
CMD ["gunicorn", "--workers=1", "--timeout=3600", "--bind=0.0.0.0:5000", "app:create_app()"]

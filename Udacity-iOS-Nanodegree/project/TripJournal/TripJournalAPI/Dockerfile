FROM python:3.11.3-slim

WORKDIR /usr/src/trip-journal

# Copy only requirements first to leverage Docker cache
COPY ./requirements.txt /usr/src/trip-journal/requirements.txt

# Install requirements and clean up
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . /usr/src/trip-journal/

# Create static folder
RUN mkdir /usr/src/trip-journal/static

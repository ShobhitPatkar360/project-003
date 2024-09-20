# Our base image
FROM node:12.2.0-alpine

# Setting our working directory
WORKDIR /node

# Copying all the code to our container
COPY . . 

# Installing the dependencies
RUN npm install
RUN npm run test
EXPOSE 8000

# Run the copied code
CMD ["node","app.js"]


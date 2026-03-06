#from image
from node:21 AS frontend-builder

#workiung dir
WORKDIR /app

# Copy the package.json and package-lock.json for dependency installation
COPY package*.json  ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

#stage 2

FROM node:21-slim 

#set up working dir
WORKDIR /app

#copying from previso build 
FROM node:21-slim

COPY --from=frontend-builder /app .

# Copy the .env.sample file to .env.local
COPY .env.docker .env.local

# Expose port 5173 for the Node.js application
EXPOSE 5173


#define the defauly commnad to run application 
CMD ['npm', 'run', 'dev','--','host']





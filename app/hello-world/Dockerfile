FROM public.ecr.aws/docker/library/node:18-alpine3.18

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install

# Bundle app source
COPY . .

# Container listens on port 3000 - the NodeJS default
EXPOSE 3000

# NodeJS will be running as PID 1 so we can SIGTERM it.
CMD [ "node", "src/index.js"]
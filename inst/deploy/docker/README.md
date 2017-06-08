# TAG

Docker configuration for the Text Analysis Gateway (TAG).



# Setting Up the Container

Run:

```bash
sudo docker pull wrathematics/tag
sudo docker run -i -t -p 3838:3838 wrathematics/tag
```

Alternatively, if you prefer/need to to work with the docker file directly:

1. Copy `Dockerfile` to your machine.
2. cd to the dir containing `Dockerfile`
3. `sudo docker build -t tag .`
4. `sudo docker run -i -t -p 3838:3838 tag`



# Using the Gateway

Go to http://localhost:3838/ in a web browser.



# Contact

If something goes wrong, please open an issue on the [github repository](https://github.com/XSEDEScienceGateways/TAG).

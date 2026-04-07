

# First Run for Deployment

In the folder specific for `gen_image_ui` deployment, say `gen_image_ui_deployment`

* Create the subfolder `storage`. This subfolder will be used by the `gen_image_ui` deployment as storage for
  - configurations
  - database
  - generated images


* Create the configuration subfolder `storage/config`

* In the configuration subfolder `storage/config`, create configuration file `.env` (i.e. `gen_image_ui_deployment/storage/config/.env`)
    <br>`.env`
    ```
    WAVESPEED_API_KEY="<your wavespeed api key>"
    ```
  Notice:
  - You will specify configurations in `.env`, including your secret keys.
  - Above only has the Wave Speed AI API key, which you can get one from [Wave Speed AI](https://wavespeed.ai/). Basicallly, you need to sign up for an account then pre-pay for some credits for their services, like with `gen_image_ui` for image generation as well as some LLM prompting for various purposes, like generate image prompt enhancement, or giving short title to image prompts.
  - More API usages as well as other configurations will be mentioned later.

* In `gen_image_ui_deployment`, create the file `docker-compose.yml`, like
    <br>`docker-compose.yml`
    ```
    services:
    gen_image_ui:
        image: trevorwslee/gen-image-ui:0.1.0  # set the desired tag; e.g. 0.1.0, latest, dev
        container_name: gen_image_ui
        ports:
        - "8080:3000"
        volumes:
        - ./storage:/app/backend/storage
        environment:
        - TZ=Asia/Hong_Kong
        restart: unless-stopped
    ```
  This is the Docker compose file for deployment of `gen_image_ui`. Notice
  - The Docker container name will be `gen_image_ui`.
  - The port mapping is `8080:3000`, which means you can access the `gen_image_ui` at `http://localhost:8080` in your browser. Rather than `8080`, you may have your preferred port for `gen_image_ui`.
  - The volume mapping is `./storage:/app/backend/storage`, which means that the `gen_image_ui` Docker container will use the subfolder `storage` for configurations and data storage, as hinted previously.
  - The environment variable `TZ` is set to `Asia/Hong_Kong` for setting the timezone. You can set it to one that matches your location.   


To bring up the `gen_image_ui` Docker container up, in the folder `gen_image_ui_deployment`, run
```
docker compose up -d
```
If you want to, can watch the logs of the `gen_image_ui` Docker container by running
```
docker compose logs -f
```

Now that the `gen_image_ui` Docker container is up, you can access the `gen_image_ui` at `http://localhost:8080` in your browser. You should see the `gen_image_ui` home page like:

![](imgs/20260402142110.png)


# First Image Generation

Apparently, you can input the generate image prompt to the `Prompt` text box.

Nevertheless, assuming that you don't yet have an idea on what image to generate

1) You can click the `Sample Prompts` button <img src="imgs/btn_sample_prompts.svg" style="zoom:20%;"/> to see some sample prompts.

  ![](imgs/20260402150227.png)

  After selecting the sample prompt, say the 1st one

  ![](imgs/20260402150527.png)

  you click the `Generate Image` button <img src="imgs/20260402154842.png" style="zoom:20%;"/> to start the image generation.
  
  ![](imgs/20260402152851.png)

  Notice that you selected to use the model <img src="imgs/btn_ai.svg" style="zoom:20%;" /> `wavespeed:z-image/turbo -- 200/$`, which is the LLM model [`z-image/turbo` provided by Wave Speed AI](https://wavespeed.ai/docs/docs-api/wavespeed-ai/z-image-turbo), and [as recorded] the cost of image generation using the model is 200 images per 1 USD.
  

  Let's try the second sample

  ![](imgs/20260402153225.png)

# Image Generation History

If you want to go back to previous image generation, you can click the `Prompt History` button <img src="imgs/btn_prompt_history.svg" style="zoom:20%;"/> to see the history of image generations. 

![](imgs/20260402154105.png)

# Generate Image Prompt Enhancement

If you find that the image prompt "feels" too simple and boring, you can click the `Enhance Prompt` button <img src="imgs/btn_enhance_prompt.svg" style="zoom:20%;"/> to enhance the image generation prompt by the configured LLM model, so that that image prompt becomes more detailed and interesting.


![](imgs/20260407162918.png)
Notice that I have specified some prompt enhancement hints:
* The enhanced prompt should produce a Cartoon style image
* The enhanced prompt should overlay some text on the image, automatically

![](imgs/20260407163053.png)

After the prompt enhancement, certainly, you can modify the enhanced prompt as you see fit ... or simply click the `Generate Image` button <img src="imgs/20260402154842.png" style="zoom:20%;"/> ... wait and see the result


![](imgs/20260407163147.png)


At this point, if you find that the image is still missing something, like missing a good background, maybe you can try "tell the enhancement LLM to add what is missing for you", like

![](imgs/20260407164718.png)

like add the the prompt 
```
*** modification ***
- give the image a fun background that matches image
```
and then click the `Enhance Prompt` button <img src="imgs/btn_enhance_prompt.svg" style="zoom:20%;"/> again to further enhance the image prompt

![](imgs/20260407164742.png)


this time, maybe skip all the hints ... see if the enhancement prompt LLM can help you to enhancement the generate image prompt as you hope to

![](imgs/20260407164915.png)

Not exactly just adding a background to the original image ... but still ... fun to see the results of iteratively prompt enhancements


# Use Another LLM Model for Image Generation

What about using a different LLM model for image generation, like a more expensive `nano-banana` model provided by Wave Speed AI

![](imgs/20260407170843.png)

![](imgs/20260407171133.png)

Indeed, `gen_image_ui` supports some selected LLM models provided by Wave Speed AI:
* from `z-image/turbo`
* to `nano-banana` / `nano-banana-2` / `nano-banana-pro`
* including LLM models that generate image in SVG format, like `recraft-v3-svg`



![](imgs/20260407172148.png)

Even though it is hard to say that the resulting image is impressive, but considering that 
<img src="imgs/img_recraft-v3-svg_16-9_bf01612caedf4a23ad997ac35ef7a398.svg" style="zoom:20%;"/>
is in SVG format, it is impressive afterall.




![](imgs/20260407171954.png)










XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXxx



--------------------------------------------

![](imgs/20260407164828.png)




![](imgs/20260402212627.png)
![](imgs/20260402212751.png)
![](imgs/20260402212829.png)



-----------------------------------


![](imgs/20260402213250.png)




--------------------------


<img src="imgs/btn_ai.svg" style="zoom:50%;" />
<img src="imgs/btn_sample_prompts.svg" style="zoom:50%;"/>
<img src="imgs/btn_prompt_history.svg" style="zoom:50%;"/>
<img src="imgs/btn_enhance_prompt.svg" style="zoom:50%;"/>

-----------------------------------

https://hub.docker.com/r/trevorwslee/gen-image-ui
![](imgs/20260402103900.png)



https://wavespeed.ai/
![](imgs/20260402104011.png)

https://platform.stability.ai/

![](imgs/20260402104121.png)


https://ttapi.io/
![](imgs/20260402104214.png)

https://openrouter.ai/
![](imgs/20260402104319.png)
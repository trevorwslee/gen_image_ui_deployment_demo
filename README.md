# UI for AI Image Generation `gen_image_ui` Deployment Demo

The app `gen_image_ui` is a web UI for image generation with LLM / Stable Diffusion / Midjourney, via APIs like WaveSpeed AI / platform.stability.ai / TTAPI. This repository is a demo for deployment of `gen_image_ui` with Docker Compose, as well as some usage examples of `gen_image_ui` for image generation.

The demo will mostly demonstrate using the APIs provided by Wave Speed AI for image generation, hence, I will assume
that you also have an account with [Wave Speed AI](https://wavespeed.ai/) in order to follow along.

Even if you follow along exactly, I am pretty sure the results of your own running of `gen_image_ui` will not be the same as shown here.
I believe this is the fun part of using AI for generating images -- the resuls might often be surprising and inspiring.




# Deployment with Docker Compose

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
          image: trevorwslee/gen-image-ui:0.1.1  # set the desired tag; e.g. 0.1.1, latest, dev
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

However, let's pretend that you don't yet have an idea on what image to generate

You can click the `Sample Prompts` button <img src="imgs/btn_sample_prompts.svg" style="zoom:20%;"/> to see some sample prompts.

![](imgs/20260402150227.png)

After selecting the sample prompt, say the 1st one

![](imgs/20260402150527.png)

you click the `Generate Image` button <img src="imgs/20260402154842.png" style="zoom:20%;"/> to start the image generation.

![](imgs/20260402152851.png)

Notice that you are defaulted to use the AI model <img src="imgs/btn_ai.svg" style="zoom:20%;" /> `wavespeed:z-image/turbo -- 200/$`, which is the LLM model [`z-image/turbo` provided by Wave Speed AI](https://wavespeed.ai/docs/docs-api/wavespeed-ai/z-image-turbo), and [as recorded] the cost of image generation using the model is 200 images per 1 USD.


Let's try the second sample

![](imgs/20260402153225.png)

# Image Generation History

If you want to go back to previous image generation, you can click the `Prompt History` button <img src="imgs/btn_prompt_history.svg" style="zoom:20%;"/> to see the history of image generations. 

![](imgs/20260402154105.png)

# Generate Image Prompt Enhancement

If you find that the image prompt feels too simple and boring, you can click the `Enhance Prompt` button <img src="imgs/btn_enhance_prompt.svg" style="zoom:20%;"/> to enhance the image generation prompt by the configured LLM model, so that the image prompt becomes more detailed and interesting.


![](imgs/20260407162918.png)
Notice that I have specified some prompt enhancement hints:
* The enhanced prompt should produce a Cartoon style image
* The enhanced prompt should overlay some text on the image, automatically

![](imgs/20260407163053.png)

After the prompt enhancement, certainly, you can modify the enhanced prompt as you see fit ... or simply click the `Generate Image` button <img src="imgs/20260402154842.png" style="zoom:20%;"/> ... wait and see the result


![](imgs/20260407163147.png)


At this point, if you find that the image is still missing something, like missing a good background, maybe you can try "tell the enhancement LLM to add what is missing for you", like

![](imgs/20260407164718.png)

like add to the end of the prompt 
```
*** modification ***
- give the image a fun background that matches image
```
and then click the `Enhance Prompt` button <img src="imgs/btn_enhance_prompt.svg" style="zoom:20%;"/> again to further enhance the image prompt

![](imgs/20260407164742.png)


this time ... maybe skip all the hints ... see if the enhancement prompt LLM can help you to enhancement the generate image prompt as you hope to

![](imgs/20260407164915.png)

Not exactly just adding a background to the original image ... but still ... fun to see the results of iterative prompt enhancements


# Use Another LLM Model for Image Generation

What about using a different LLM model for image generation, like a more expensive `nano-banana` model provided by Wave Speed AI?

You can select your choice of available AI models for image generation by clicking the `AI` list box <img src="imgs/btn_ai.svg" style="zoom:20%;" /> to select the desired AI model for image generation.

![](imgs/20260407170843.png)

![](imgs/20260407171133.png)

Wow!

Indeed, `gen_image_ui` supports some selected LLM models provided by Wave Speed AI
* from `z-image/turbo`
* to `nano-banana` / `nano-banana-2` / `nano-banana-pro`
* including LLM models that generate image in SVG format, like `recraft-20b-svg` / `recraft-v3-svg`

![](imgs/20260407181349.png)

Even though it is hard to say that the resulting image is impressive, but considering that 
<img src="imgs/img_recraft-20b-svg_16-9_f5450cbbaefc4047bf40bcd729855abc.svg" style="zoom:10%;"/>
is in SVG format, it is impressive afterall.


# Ideas for Image Generation

If you are trying to get some ideas on what image to generate, you can click the `Init Prompt` button <img src="imgs/btn_init_prompt.svg" style="zoom:20%;"/> to get some initial image generation prompt ideas, say, by getting "quote of the day" 

![](imgs/20260407214803.png)

![](imgs/20260407214829.png)

Before you click the `Generate Image` button, you may first want to enhance the prompt first

![](imgs/20260407214925.png)

![](imgs/20260407215016.png)

Let's see the result after image generation

![](imgs/20260407215103.png)

Not very good. Maybe the model will work better without overlaying text.

Let's try `grok-imagine-image`

![](imgs/20260407215259.png)

Wow!

Just wonder what `nano-banana-pro` will give us!



# Initialize Prompt By Asking LLM Questions

The `Init Prompt` button is also hooked up with LLM, and the LLM is configured with various tools, like "get weather info", of course, most likely, you will need to apply for API keys for the services

Assuming you have configured the API key work "get weather info" from [OpenWeather](https://home.openweathermap.org/users/sign_up) -- ***sign up*** for an `APP_ID` of their ***version 2.5*** APIs.

And added the API key to the configuration file `.env` like
```
OPEN_WEATHER_MAP_APP_ID="<your open weather map app id>"
DEFAULT_LOCATION_FOR_WEATHER_INFO="Hong Kong"
```

You then can simply put your question for LLM in the prompt text box

![](imgs/20260408105820.png)

then click the `Init Prompt` button <img src="imgs/btn_init_prompt.svg" style="zoom:20%;"/> to ask the question to LLM, and get the answer from LLM 

![](imgs/20260408105907.png)

The answer come up is in text form. Actually, you can by-pass LLM, and directly type the text yourself

![](imgs/20260408110034.png)

Then, you can try to enhance what is in the prompt text area by clicking the `Enhance Prompt` button 

![](imgs/20260408110155.png)


It is fun to see what the result of the enhanced prompt is

![](imgs/20260408110424.png)

Another useful LLM tool is "web search" provided by [Tavily](https://www.tavily.com/)

Assuming you have put the API key for "web search" from [Tavily](https://www.tavily.com/) in the configuration file `.env` like
```

TAVILY_API_KEY="your tavily api key"
```

Then, you can ask LLM a question that requires web search, like "What is the most famous painting in the world?" in the prompt text box

![](imgs/20260408111515.png)

![](imgs/20260408111537.png)

![](imgs/20260408111911.png)

![](imgs/20260408112009.png)

![](imgs/20260408112217.png)

![](imgs/20260408112313.png)

XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXx


![](imgs/20260408110227.png)




Certainly, in many situations, you will need to configure with the appropriate API keys in order to enable the LLM tools, like "get weather info". Indeed, you can get


Since `AWeatherClock` needs to gather current weather info from [OpenWeather](https://home.openweathermap.org/users/sign_up),
please, ***sign up*** for an `APP_ID` of their ***version 2.5*** APIs. 





zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz


<img src="imgs/btn_ai.svg" style="zoom:50%;" />
<img src="imgs/btn_sample_prompts.svg" style="zoom:50%;"/>
<img src="imgs/btn_prompt_history.svg" style="zoom:50%;"/>
<img src="imgs/btn_enhance_prompt.svg" style="zoom:50%;"/>
<img src="imgs/btn_init_prompt.svg" style="zoom:50%;"/>

zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
![](imgs/20260407215210.png)





![](imgs/20260407180857.png)

Even though it is hard to say that the resulting image is impressive, but considering that 
<img src="imgs/img_recraft-20b-svg_16-9_d8e2db69b7644c4aa1e0fa1e90e730de.svg" style="zoom:10%;"/>
is in SVG format, it is impressive afterall.



########################################


![](imgs/20260407172148.png)

Even though it is hard to say that the resulting image is impressive, but considering that 
<img src="imgs/img_recraft-v3-svg_16-9_bf01612caedf4a23ad997ac35ef7a398.svg" style="zoom:10%;"/>
is in SVG format, it is impressive afterall.





![](imgs/20260407181221.png)



![](imgs/20260407180800.png)
![](imgs/20260407180857.png)



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
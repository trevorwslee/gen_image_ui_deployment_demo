# AI 圖像生成 UI `gen_image_ui` 部署示範

應用程式 `gen_image_ui` 是一個用於 AI 圖像生成的 Web UI，可透過 WaveSpeed AI / platform.stability.ai / TTAPI 提供的 API 搭配 LLM / Stable Diffusion / Midjourney 進行圖像生成。此 GitHub 儲存庫示範如何以 Docker Compose 部署 `gen_image_ui`，以及一些使用 `gen_image_ui` 進行圖像生成的範例。


- [AI 圖像生成 UI `gen_image_ui` 部署示範](#ai-圖像生成-ui-gen_image_ui-部署示範)
- [使用 Docker Compose 部署](#使用-docker-compose-部署)
- [第一次生成圖像](#第一次生成圖像)
- [圖像生成歷史](#圖像生成歷史)
- [生成圖像提示詞增強](#生成圖像提示詞增強)
- [使用另一個 LLM 模型生成圖像](#使用另一個-llm-模型生成圖像)
- [圖像生成靈感](#圖像生成靈感)
- [透過詢問 LLM 問題初始化提示詞](#透過詢問-llm-問題初始化提示詞)
- [使用 Midjourney / Stable Diffusion 進行圖像生成](#使用-midjourney--stable-diffusion-進行圖像生成)
- [用於 Chat Completions 的 LLM](#用於-chat-completions-的-llm)
- [Enjoy!](#enjoy)



此示範主要會展示如何使用 Wave Speed AI 提供的 API 進行圖像生成。
因此，如果你想跟著操作，我會假設你也有 [Wave Speed AI](https://wavespeed.ai/) 的帳戶。

即使你完全照著做，我也幾乎可以確定你實際執行 `gen_image_ui` 的結果不會和這裡展示的一樣。
我認為這正是使用 AI 生成圖像有趣的地方：結果往往可能令人驚喜，也帶來靈感。

確實，這也是 `gen_image_ui` 的核心想法：提供一個 Web UI，讓你可以享受 AI 圖像生成的樂趣，也享受 AI 生成圖像帶來的驚喜與啟發。




# 使用 Docker Compose 部署

在專門用於部署 `gen_image_ui` 的資料夾中，例如 `gen_image_ui_deployment`

* 建立子資料夾 `storage`。這個子資料夾會被 `gen_image_ui` 部署用作儲存空間，包含
  - 設定檔
  - 資料庫
  - 生成了的圖像


* 建立設定子資料夾 `storage/config`

* 在設定子資料夾 `storage/config` 中，建立設定檔 `.env`（即 `gen_image_ui_deployment/storage/config/.env`）
    <br>`.env`，可參考 [the `.env.example` in the repository](https://github.com/trevorwslee/gen_image_ui_deployment_demo/blob/main/gen_image_ui_deployment/storage/config/.env.example)
    ```
    WAVESPEED_API_KEY="<你的 wavespeed API金鑰>"
    ```
  注意：
  - 你會在 `.env` 中指定設定，包含你的 secret keys (API金鑰)。
  - 上面只包含 Wave Speed AI API 金鑰，你可以在 [Wave Speed AI](https://wavespeed.ai/) 取得。基本上，你需要先註冊帳戶，然後預付一些 credits 來使用其服務，例如透過 `gen_image_ui` 生成圖像，以及各種 LLM prompting 用途（像是生成圖像提示詞增強，或為圖像提示詞產生短標題）。
  - 更多 API 用法及其他設定會在後面提到。

* 在 `gen_image_ui_deployment` 中建立檔案 `docker-compose.yml`，例如
    <br>`docker-compose.yml`，可參考 [this one in the repository](https://github.com/trevorwslee/gen_image_ui_deployment_demo/blob/main/gen_image_ui_deployment/docker-compose.yml)
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
  這是用於部署 `gen_image_ui` 的 Docker compose 檔。注意：
  - Docker container name 會是 `gen_image_ui`。
  - port mapping 是 `8080:3000`，表示你可以在瀏覽器透過 `http://localhost:8080` 存取 `gen_image_ui`。你也可以把 `8080` 改成自己偏好的埠號。
  - volume mapping 是 `./storage:/app/backend/storage`，表示 `gen_image_ui` Docker container 會使用 `storage` 子資料夾來儲存設定與資料，正如前面提到。
  - environment variable `TZ` 設為 `Asia/Hong_Kong` 以設定時區。你可以改成符合你所在地的值。`TZ` 的值可參考 [List of tz database time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)。

要啟動 `gen_image_ui` web server（也就是啟動 `gen_image_ui` Docker container），在 `gen_image_ui_deployment` 資料夾中執行
```
docker compose up -d
```
若你想查看 `gen_image_ui` Docker container 的日誌，可執行
```
docker compose logs -f
```

現在 `gen_image_ui` Docker container 已啟動，你可以在瀏覽器透過 `http://localhost:8080` 存取 `gen_image_ui`。你應該會看到 `gen_image_ui` 首頁如下：

![](imgs/20260409161143.png)


# 第一次生成圖像

很明顯，你可以在 `提示詞` 文字框輸入 generate image prompt。

不過，先假設你目前還沒有想好要生成什麼圖像。

你可以點擊 `提示詞例子` 按鈕 <img src="imgs/btn_sample_prompts.svg" style="zoom:20%;"/> 來查看一些 sample prompts。

![](imgs/20260409161352.png)



選取提示詞例子（例如第二個）後

![](imgs/20260409161828.png)

點擊 `生成圖像` 按鈕 <img src="imgs/20260402154842.png" style="zoom:20%;"/> 開始生成圖像。

![](imgs/20260409162003.png)

注意，預設會使用 AI 模型 <img src="imgs/btn_ai.svg" style="zoom:20%;" /> `wavespeed:z-image/turbo -- 200/$`，也就是 Wave Speed AI 提供的 LLM model [`z-image/turbo`](https://wavespeed.ai/docs/docs-api/wavespeed-ai/z-image-turbo)，且 [根據記錄] 使用此模型生成圖像的成本是每 1 USD 可生成 200 張圖像。


來試試第六個提示詞例子。

![](imgs/20260409162232.png)


# 圖像生成歷史

如果你想回到先前的圖像生成結果，可以點擊 `提示詞歷史` 按鈕 <img src="imgs/btn_prompt_history.svg" style="zoom:20%;"/> 查看圖像生成歷史。

![](imgs/20260409163618.png)


# 生成圖像提示詞增強

如果你覺得圖像提示詞太簡單、太無聊，可以點擊 `增強提示詞` 按鈕 <img src="imgs/btn_enhance_prompt.svg" style="zoom:20%;"/>，讓設定好的 LLM model 幫你增強圖像生成提示詞，讓提示詞更具細節、更有趣。


![](imgs/20260409163943.png)
注意我指定了一些增強提示詞選項：
* 增強後的提示詞應該產生卡通風格圖像
* 增強後的提示詞應自動在圖像上疊加一些文字

![](imgs/20260409164137.png)

提示詞增強後，當然你可以依需求修改增強後的提示詞……或直接點擊 `生成圖像` 按鈕 <img src="imgs/20260402154842.png" style="zoom:20%;"/>……等待並查看結果。

![](imgs/20260409164240.png)


此時，如果你發現圖像仍缺少某些元素，例如缺少好的背景，也許你可以嘗試「告訴增強提示詞 LLM 幫你補上缺少的內容」，例如

![](imgs/20260409164525.png)

在提示詞末尾加上
```
***修改***
- 加上與貓頭鷹相匹配的背景
```
然後再次點擊 `增強提示詞` 按鈕 <img src="imgs/btn_enhance_prompt.svg" style="zoom:20%;"/> 以進一步增強圖像提示詞

![](imgs/20260409164801.png)


這次……也許把選項全部省略……看看增強提示詞 LLM 是否能如你所願，幫你增強圖像生成提示詞。
![](imgs/20260409165025.png)

不完全只是替原圖加上背景……但看迭代增強提示詞的結果依然很有趣。


# 使用另一個 LLM 模型生成圖像

如果改用不同的 LLM 模型來生成圖像呢？例如使用 Wave Speed AI 提供、成本較高的 `nano-banana-2` 模型？

你可以點擊 `AI` 下拉清單 <img src="imgs/btn_ai.svg" style="zoom:20%;" /> 來選擇可用的 AI models 作為圖像生成模型。

![](imgs/20260409165416.png)

![](imgs/20260409165623.png)


確實，`gen_image_ui` 支援一些由 Wave Speed AI 提供的指定 LLM models：
* 從 `z-image/turbo`
* 到 `nano-banana` / `nano-banana-2` / `nano-banana-pro`
* 也包含可以產生 SVG 格式圖像的 LLM models，例如 `recraft-20b-svg` / `recraft-v3-svg`


# 圖像生成靈感

如果你正在想要生成什麼圖像，可以點擊 `初始化提示詞` 按鈕 <img src="imgs/btn_init_prompt.svg" style="zoom:20%;"/> 取得一些初始圖像生成提示詞靈感，例如「quote of the day」。

![](imgs/20260407214803.png)

![](imgs/20260407214829.png)

在點擊 `Generate Image` 按鈕前，你也許可以先點擊 `Enhance Prompt` 按鈕 <img src="imgs/btn_enhance_prompt.svg" style="zoom:20%;"/> 增強提示詞，看看會有什麼差異。

![](imgs/20260407214925.png)

![](imgs/20260407215016.png)

來看看生成圖像後的結果。

![](imgs/20260407215103.png)

不太好。也許模型在不疊加文字時效果更好。

我們試試 `grok-imagine-image`。

![](imgs/20260407215259.png)

Wow!

很好奇 `nano-banana-pro` 會給出什麼結果！




讓我們試試更抽象的主題，例如 Chinese poems。點擊 `Init Prompt` 按鈕 <img src="imgs/btn_init_prompt.svg" style="zoom:20%;"/> 並選擇「Chinese poem」。

![](imgs/20260409094855.png)

就算你看不懂 Chinese poem 也沒關係，因為即使我是華人，也有很多 Chinese poems 看不懂。

儘管如此，還是點擊 `Enhance Prompt` 按鈕 <img src="imgs/btn_enhance_prompt.svg" style="zoom:20%;"/> 來看看 LLM 如何理解 Chinese poem。


![](imgs/20260409095017.png)

使用 `qwen-image` model 會產生如下結果：

![](imgs/20260409095147.png)




# 透過詢問 LLM 問題初始化提示詞

`Init Prompt` 按鈕也串接了 LLM，而 LLM 設定了各種 tools，例如「get weather info」。當然，多半你需要先為這些服務申請 API keys。

假設你已為 [OpenWeather](https://home.openweathermap.org/users/sign_up) 的「get weather info」設定好 API key，並且已註冊其 ***version 2.5*** APIs 的 `APP_ID`。

並且已將 API key 加入 `.env` 設定檔：
```
OPEN_WEATHER_MAP_APP_ID="<your open weather map app id>"
DEFAULT_LOCATION_FOR_WEATHER_INFO="Hong Kong"
```

接著你就可以直接在 prompt 文字框輸入給 LLM 的問題。

![](imgs/20260408105820.png)

然後點擊 `Init Prompt` 按鈕 <img src="imgs/btn_init_prompt.svg" style="zoom:20%;"/> 向 LLM 發問，並取得 LLM 回答。

![](imgs/20260408105907.png)

回答會以文字形式出現。其實你也可以略過 LLM，直接手動輸入文字。

![](imgs/20260408110034.png)

接著你可以點擊 `Enhance Prompt` 按鈕 <img src="imgs/btn_enhance_prompt.svg" style="zoom:20%;"/>，嘗試增強 prompt 文字區中的內容。

![](imgs/20260408110155.png)


看看增強後提示詞產生的結果也很有趣。

![](imgs/20260408110424.png)


另一個有用的 LLM tool 是由 [Tavily](https://www.tavily.com/) 提供的「web search」。

假設你已把 [Tavily](https://www.tavily.com/) 的「web search」API key 放進 `.env` 設定檔：
```

TAVILY_API_KEY="your tavily api key"
```

那麼你可以在 prompt 文字框詢問一個 [likely] 需要 web search 的問題，例如：```What is the highest mountain in the world?```

![](imgs/20260408172524.png)

![](imgs/20260408172551.png)

![](imgs/20260408172739.png)

再一次，點擊 `Enhance Prompt` 按鈕 <img src="imgs/btn_enhance_prompt.svg" style="zoom:20%;"/> 看看 LLM 會產出什麼提示詞。

![](imgs/20260408172810.png)

![](imgs/20260408174231.png)

相當不錯。注意，用於生成圖像的 LLM model 是 `wavespeed:flux-2-turbo -- 100/$`（`100/$` 表示每 1 USD 可生成 100 張圖像），它比 `z-image/turbo`（`200/$`）更昂貴，而生成結果也比先前用 `z-image/turbo` 的更好。


# 使用 Midjourney / Stable Diffusion 進行圖像生成

也可以透過 `gen_image_ui` 使用 Midjourney / Stable Diffusion 進行圖像生成。
- Midjourney 的支援服務提供者是 [TTAPI](https://www.ttapi.com/)
- Stable Diffusion 的支援服務提供者是 [platform.stability.ai](https://platform.stability.ai/)

如果你要使用 Midjourney / Stable Diffusion 進行圖像生成，需先取得服務 API keys，並將它們放進 `.env` 設定檔：
```
STABILITY_API_KEY="..."
TT_API_KEY="..."
```
![](imgs/20260408183716.png)

![](imgs/20260408183812.png)


# 用於 Chat Completions 的 LLM

Web UI `gen_image_ui` 在多種用途上會用到 LLM "chat completions"，例如提示詞增強、為圖像提示詞產生短標題等。

如果你願意，也可以使用 [OpenRouter](https://openrouter.ai/) 提供的 LLM。只要把 OpenRouter API key 放進 `.env` 設定檔：
```
OPENROUTER_API_KEY="<your openrouter api key>"
```
當 OpenRouter API key 已設定時，"chat completions" 的預設 LLM provider 會是 OpenRouter。

你可以在 `.env` 中指定要用於 "chat completions" 的 LLM model：
```
OPENAI_MODEL="..."
```
這個設定適用於使用 Wave Speed AI 的 LLM models / OpenRouter LLM models 進行 "chat completions"。

是的，你其實也可以直接選擇使用 OpenAI 的 "chat completions"。只要在 `.env` 中設定 OpenAI API key：
```
OPENAI_API_KEY="<your openai api key>"
```
（因為我住在 Hong Kong，沒有機會使用 OpenAI API，所以我沒有實測。不過我相信它應該可以正常運作。）

你也可以試試本地部署 LLM models，例如 `gemma-4-e4b-it`。以下示範透過 [LM Studio](https://lmstudio.ai/) 進行這類設定：

1) 設定 LM Studio，啟動 Local Server

    ![](imgs/20260409124504.png)

    注意：
    - port 是 `8877`；你可改成偏好的埠號
    - 已啟用 "Serve on Local Network"；你會需要這個設定，因為對 `gen_image_ui` web server 來說，`localhost` 是執行它的 container 環境，而 LLM Local Server 則執行在你本地網路中的某處
    - 可看到 LLM Local Server 的 "reachable at" 是 `http://192.168.0.127:8877`；你的 IP address 當然會不同

2) 在 `gen_image_ui` 設定檔 `.env` 加入
    ```
    OPENAI_API_KEY="lmstudio"
    OPENAI_BASE_URL="http://192.168.0.127:8877/v1"
    OPENAI_MODEL="gemma-4-e4b-it"
    ```
    注意：
    - 即使你的 LM Studio Local Server 不需要 key，仍然必須把 `OPENAI_API_KEY` 設成某個值
    - `OPENAI_BASE_URL` 需指定符合你 LM Studio Local Server 的 IP 與 port

就是這樣。


# Enjoy!

盡情享受 `gen_image_ui`！

> 願平安與你同在！
> 願上帝祝福你！
> Jesus loves you!
> Amazing Grace!

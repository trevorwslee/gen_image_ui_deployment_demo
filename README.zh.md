# AI 圖像生成 UI `gen_image_ui` 部署示範

應用程式 `gen_image_ui` 是一個用於 AI 圖像生成的 Web UI，可透過 WaveSpeed AI / platform.stability.ai / TTAPI 提供的 **按需付費** APIs 搭配 LLM / Stable Diffusion / Midjourney 進行圖像生成。 此 GitHub 專案示範如何以 Docker Compose 部署 `gen_image_ui`，以及一些使用 `gen_image_ui` 進行圖像生成的範例。


- [AI 圖像生成 UI `gen_image_ui` 部署示範](#ai-圖像生成-ui-gen_image_ui-部署示範)
- [使用 Docker Compose 部署](#使用-docker-compose-部署)
- [第一次生成圖像](#第一次生成圖像)
- [圖像生成歷史](#圖像生成歷史)
- [生成圖像提示詞增強](#生成圖像提示詞增強)
- [使用另一個 LLM 模型生成圖像](#使用另一個-llm-模型生成圖像)
- [圖像生成靈感](#圖像生成靈感)
- [透過詢問 LLM 問題初始化提示詞](#透過詢問-llm-問題初始化提示詞)
- [Enjoy!](#enjoy)



此示範主要會展示如何使用 Wave Speed AI 提供的 APIs 進行圖像生成。
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
  - 你會在 `.env` 中指定設定，也包含你的 secret keys (API金鑰)。
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

如果你正在想要生成什麼圖像，可以點擊 `初始化提示詞` 按鈕 <img src="imgs/btn_init_prompt.svg" style="zoom:20%;"/> 取得一些初始圖像生成提示詞靈感，例如「每日名言」。


![](imgs/20260416160940.png)

![](imgs/20260416160826.png)

![](imgs/20260416161053.png)

![](imgs/20260416161132.png)

![](imgs/20260416161231.png)


AI 模型 `grok-imagine-image` 已經非常好了，很好奇 `nano-banana-pro` 會給出什麼結果！


# 透過詢問 LLM 問題初始化提示詞

`初始化提示詞` 按鈕也串接了 LLM，而 LLM 設定了各種 tools，例如「get weather info」。當然，多半你需要先為這些服務申請 API keys。

假設你已為 [OpenWeather](https://home.openweathermap.org/users/sign_up) 的「get weather info」設定好 API key，並且已註冊其 ***version 2.5*** APIs 的 `APP_ID`。

並且已將 API key 加入 `.env` 設定檔：
```
OPEN_WEATHER_MAP_APP_ID="<your open weather map app id>"
DEFAULT_LOCATION_FOR_WEATHER_INFO="Hong Kong"
```

接著你就可以直接在 `提示詞` 文字框輸入給 LLM 的問題。

![](imgs/20260416162040.png)

然後點擊 `初始化提示詞` 按鈕 <img src="imgs/btn_init_prompt.svg" style="zoom:20%;"/> 向 LLM 發問，並取得 LLM 回答。

![](imgs/20260416162447.png)

回答會以文字形式出現。其實你也可以略過 LLM，直接手動輸入文字。

![](imgs/20260416162607.png)


接著你可以點擊 `增強提示詞` 按鈕 <img src="imgs/btn_enhance_prompt.svg" style="zoom:20%;"/>，嘗試增強 `提示詞` 文字框中的內容。

![](imgs/20260416162802.png)


看看增強後提示詞產生的結果也很有趣。

![](imgs/20260416162945.png)

Let's try a Bible verse. Yes, LLM can also lookup Bible verse in case you forgot the exact wording of the verse.

![](imgs/20260416163343.png)

![](imgs/20260416163513.png)

![](imgs/20260416163449.png)

![](imgs/20260416163554.png)

![](imgs/20260416163946.png)


讓我們來嘗試一些更有趣的東西——動漫風格

![](imgs/20260416164502.png)

![](imgs/20260416164338.png)

# Enjoy!

盡情享受 `gen_image_ui`！

> 願平安與你同在！
> 願上帝祝福你！
> Jesus loves you!
> Amazing Grace!

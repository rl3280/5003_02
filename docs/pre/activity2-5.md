I am working on a Levono Thinkpad X14 Elite, using VSCode.
make a procedure of steps that i can verify one by one on the following:
1) install Continue extension in VS Code
2) install geniex
3) make sure geniex is working through Continue in VS Code.
4) install Qwen3-VL-4B-Instruct and Llama-3.1-8B-Instruct
5) test simple prompt to make sure Hexagon NPU and Adreno GPU are being used.
6) install CIDOC-CRM in JSON-LD Context format
7) install Mingei Crafts Ontology (CrO) .ttl and convert to .jsonld
8) Configure VS Code (.continue/config.json) to attach your schema files (CIDOC-CRM and CrO .jsonld) to any prompt using the @ symbol

Here is the step-by-step procedure to set up your environment on your Lenovo ThinkPad X14 Elite (Snapdragon X Elite ARM64), verify every stage incrementally, and link your ontology schemas directly into VS Code with Continue and local GenieX.

---

### Step 1: Install Continue Extension in VS Code

1. Open **VS Code**.
2. Press `Ctrl + Shift + X` to open the **Extensions** marketplace.
3. Search for `Continue` (by `Continue.continue`).
4. Click **Install**.
5. **Verification Check:** Press `Ctrl + Shift + L` (or click the Continue icon on the sidebar). The Continue chat panel should open on the right side of your editor.

---

### Step 2: Install GenieX

1. Open your terminal in VS Code (`Ctrl + ~`) or Windows Terminal (PowerShell / WSL).
2. Install the GenieX runtime via the installer script:
```bash
curl -fsSL https://qaihub-public-assets.s3.us-west-2.amazonaws.com/qai-hub-geniex/install.sh | sh

```


3. Add GenieX to your path if not added automatically:
```bash
export PATH="$HOME/.local/bin:$PATH"

```


4. **Verification Check:** Run:
```bash
geniex --version

```


*Expected Output:* Reports `GenieX CLI Version` alongside underlying runtime engines (`QAIRT` for Hexagon NPU and `llama.cpp` for Adreno GPU/CPU).

---

### Step 3: Verify GenieX is Working via OpenAI Server Mode

1. Start the GenieX local API server in your terminal:
```bash
geniex serve --port 18181

```


2. Leave that terminal running.
3. Open a second terminal window and send a quick `curl` test:
```bash
curl http://127.0.0.1:18181/v1/models

```


4. **Verification Check:** The endpoint returns an HTTP 200 JSON payload listing available local models.

---

### Step 4: Install Qwen3-VL-4B-Instruct and Llama-3.1-8B-Instruct

1. Pull the quantized vision model for visual extraction (GGUF or AI Hub bundle):
```bash
geniex pull Qwen/Qwen3-VL-4B-Instruct-GGUF:Q4_0

```


2. Pull the code generation model:
```bash
geniex pull meta-llama/Llama-3.1-8B-Instruct-GGUF:Q4_0

```


3. **Verification Check:** Run:
```bash
geniex model list

```


Confirm both `Qwen3-VL-4B-Instruct` and `Llama-3.1-8B-Instruct` appear as cached models in your local model registry.

---

### Step 5: Test Simple Prompt & Verify Hardware Acceleration (NPU/GPU)

1. Test execution on the **Hexagon NPU** (`--compute npu`):
```bash
geniex infer meta-llama/Llama-3.1-8B-Instruct-GGUF:Q4_0 --compute npu --prompt "Hello from NPU"

```


2. Test execution on the **Adreno GPU** (`--compute gpu`):
```bash
geniex infer meta-llama/Llama-3.1-8B-Instruct-GGUF:Q4_0 --compute gpu --prompt "Hello from GPU"

```


3. **Verification Check:**
* Open **Task Manager** (`Ctrl + Shift + Esc`) $\rightarrow$ Performance tab.
* Verify that the **NPU (Qualcomm Hexagon)** spikes during the NPU inference command and the **GPU (Qualcomm Adreno)** registers activity during the GPU inference command.



---

### Step 6: Install CIDOC-CRM in JSON-LD Context Format

1. Create a `schema/` folder in your repository root:
```bash
mkdir -p schema

```


2. Download or place `CIDOC_CRM_v7.1.3_JSON-LD_Context.jsonld` into the `schema/` directory.
3. **Verification Check:** Validate syntax using `jq` or node:
```bash
jq . schema/CIDOC_CRM_v7.1.3_JSON-LD_Context.jsonld

```


*Expected Output:* Prints clean, formatted JSON without syntax errors.

---

### Step 7: Install Mingei Crafts Ontology (CrO) `.ttl` and Convert to `.jsonld`

1. Save your downloaded `cro.ttl` file inside the `schema/` directory (`schema/cro.ttl`).
2. Run a short Python conversion script using `rdflib`:
```bash
python3 -c "
import rdflib
g = rdflib.Graph()
g.parse('schema/cro.ttl', format='turtle')
g.serialize(destination='schema/cro.jsonld', format='json-ld')
print('Successfully converted cro.ttl to schema/cro.jsonld')
"

```


3. **Verification Check:** Run `ls -l schema/` and verify `cro.jsonld` exists and is non-empty.

---

### Step 8: Configure VS Code (`.continue/config.json`) to Attach Schemas via `@`

1. Open or create `.continue/config.json` in your project root or user profile (`~/.continue/config.json`).
2. Paste the following configuration:

```json
{
  "models": [
    {
      "title": "GenieX - Qwen3-VL (Vision)",
      "provider": "openai",
      "model": "Qwen/Qwen3-VL-4B-Instruct-GGUF:Q4_0",
      "apiBase": "http://127.0.0.1:18181/v1",
      "apiKey": "geniex"
    },
    {
      "title": "GenieX - Llama-3.1 (Code)",
      "provider": "openai",
      "model": "meta-llama/Llama-3.1-8B-Instruct-GGUF:Q4_0",
      "apiBase": "http://127.0.0.1:18181/v1",
      "apiKey": "geniex"
    }
  ],
  "contextProviders": [
    {
      "name": "file",
      "params": {}
    }
  ]
}

```

3. **Final Verification Check:**
* Open the **Continue** panel (`Ctrl + Shift + L`).
* Select **GenieX - Llama-3.1 (Code)** from the model dropdown.
* Type `@cro.jsonld` or `@CIDOC_CRM_v7.1.3_JSON-LD_Context.jsonld` in the prompt input field.
* Confirm VS Code highlights and attaches the file directly into the prompt context window.

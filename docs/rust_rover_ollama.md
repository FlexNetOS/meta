# Adding Ollama to Rust Rover

To add Ollama as an AI provider in Rust Rover (JetBrains IDE), follow these steps:

### 1. Install an AI Plugin
If you haven't already, install one of the popular AI plugins that support custom providers:
- **Continue**: Highly recommended for local models.
- **Codeium**: Supports custom enterprise/local endpoints.
- **JetBrains AI Assistant**: (Note: Check the latest version for local model support; it traditionally uses JetBrains' own models).

### 2. Configure Continue (Recommended)
If using the **Continue** plugin:
1. Open the Continue side panel.
2. Click the **gear icon** (settings) at the bottom.
3. Add the following provider configuration to your `config.json`:
   ```json
   {
     "models": [
       {
         "title": "Ollama",
         "provider": "ollama",
         "model": "llama3",
         "apiBase": "http://localhost:11434"
       }
     ]
   }
   ```

### 3. Configure via HTTP Header (Alternative)
Some plugins allow you to specify an OpenAI-compatible endpoint. Ollama provides this at `/v1`:
1. Set the **API URL** to `http://localhost:11434/v1`.
2. Set the **API Key** to any string (Ollama doesn't require one by default).
3. Set the **Model Name** (e.g., `llama3`, `mistral`, `codestral`).

### 4. Verify in Meta
After configuring the IDE, you can verify your workspace is ready for Ollama by running:
```bash
meta init ollama
```
This installs the necessary context rules for your agent to work efficiently with the local model.

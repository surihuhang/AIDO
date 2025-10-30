<p align="center">
<h1 align="center">AIDO: Automated Instruction Data Optimization for Enhanced LLM Fine-Tuning</h1>

<p align="center">
    <a href=""><img src="https://img.shields.io/badge/📄-Paper-red"></a>
    <a href="https://github.com/surihuhang/AIDO/blob/main/LICENSE"><img src="https://img.shields.io/github/license/surihuhang/AIDO"></a>
    <a href=""><img src="https://img.shields.io/badge/🤗 HuggingFace-Data & Models-green"></a>
</p>

---

## 📑 Contents
- [Overview](#overview)
- [Key Highlights](#key-highlights)
- [Human Evaluation](#human-evaluation)
- [Install](#install)
- [Usage](#Usage)
---

## Overview

We propose **AIDO** — an **A**utomated **I**nstruction **D**ata **O**ptimization framework that systematically enhances instruction tuning datasets through **two key stages**:  **data selection** and **data revision**.

1. **Stage 1 — Data Selection:**  
   AIDO separates high- and low-quality samples using a **coarse-grained LLM scoring and classifing** module and a **fine-grained metric ranking and clustering** module, ensuring precise filtering of suboptimal data.

2. **Stage 2 — Data Revision:**  
   Low-quality samples are **iteratively revised** via evaluation and semantic consistency checks — correcting factual errors, completing omissions, removing redundancies, and improving alignment between instructions and responses.

![AIDO Framework](Figures/framework.png)

## Key Highlights

- **Performance Gains:**  
  - Achieves **61.02%** accuracy on *Alpaca*, surpassing prior SoTA selection and revision methods by **+2.50%** and **+2.09%**.  
  - Achieves **60.39%** accuracy on *Dolly*, outperforming prior SoTA selection and revision methods by **+3.65%** and **+2.60%**.
- **Sample Efficiency:**  
  - Uses **32.69% / 50.00% fewer samples** (vs. raw & best baseline) on *Alpaca*.  
  - Uses **20.00% / 79.66% fewer samples** (vs. raw & best baseline) on *Dolly*.  

| Dataset    | Accuracy (%) | Δ vs Raw data | Δ vs SoTA (Selection) | Δ vs SoTA (Revision) | Data Reduction (vs Raw / SoAT)(%) |
| :--------- | :----------: |:-------------:| :-------------------: | :------------------: | :-------------------------------: |
| **Alpaca** |     61.02    |     +6.69     |         +2.50         |         +2.09        |            32.69 / 50.00          |
| **Dolly**  |     60.39    |     +4.72     |         +3.65         |         +2.60        |            20.00 / 79.66          |

AIDO not only enhances **data quality** but also significantly improves **reasoning, factuality**, and **generalization** across diverse task types.

---

## Human Evaluation

We conducted a rigorous human evaluation with **three trained annotators**, employing **majority voting** to determine outcomes.  
All sample sources and versions were **anonymized** to prevent bias.  
Demonstrates AIDO’s **comprehensive correction** across all components evaluation — instructions, inputs, and outputs.

- **Lose probabilities:** 7.00% (*Alpaca*), 4.00% (*Dolly*)  
- **Instruction/Input failure rates:** reduced to 2.50% and 3.00%, respectively  
- **Output failure rates:** reduced to 6.50% and 7.00%, respectively  

<p align="center">
  <img src="Figures/huamn-eval.png" alt="AIDO Human Evaluation" width="60%">
</p>

---

## Install


---


## Usage 

### 1. Data Selection Module

#### (1) Environment Setup

Deploy the **Llama-70B** model with [vLLM](https://github.com/vllm-project/vllm):

```bash
conda activate evalscope

CUDA_VISIBLE_DEVICES=0,1 nohup python -m vllm.entrypoints.openai.api_server \
    --model MODEL_PATH \
    --served-model-name llama3.1-70B \
    --dtype bfloat16 \
    --port YOUR_API_PORT \
    --tensor-parallel-size 2 \
    --gpu-memory-utilization 0.95 \
    --max-model-len 8192 > vllm-70B.log 2>&1 &
```
Replace:
* **`YOUR_API_PORT`**: Port for your OpenAI-compatible API server (e.g., 9000)
* **`./models/Llama-3.3-70B-Instruct`**: Path to your local model

#### (1) Step 1 — Coarse-Grained LLM Scoring & Classification

---

## Contact


---


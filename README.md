<p align="center" style="border-radius: 10px">
  <img src="assets/LongLive-logo.png" width="100%" alt="logo"/>
</p>

# 🎬 LongLive: Real-time Interactive Long Video Generation

[![Paper](https://img.shields.io/badge/ArXiv-Paper-brown)](https://arxiv.org/abs/2509.22622)
[![Code](https://img.shields.io/badge/GitHub-LongLive-blue)](https://github.com/NVlabs/LongLive)
[![Model](https://img.shields.io/badge/HuggingFace-Model-yellow)](https://huggingface.co/Efficient-Large-Model/LongLive-1.3B)
[![Video](https://img.shields.io/badge/YouTube-Video-red)](https://www.youtube.com/watch?v=CO1QC7BNvig)
[![vs-Sora2](https://img.shields.io/badge/VS-Sora2-red)](https://x.com/yukangchen_/status/1973405662177529993)
[![Docs](https://img.shields.io/badge/Docs-Online-brightgreen)](https://nvlabs.github.io/LongLive/docs)
[![Demo](https://img.shields.io/badge/Demo-Page-bron)](https://nvlabs.github.io/LongLive) 
[![DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/NVlabs/LongLive)

<div align="center">

[![Watch the video](assets/video-first-frame.png)](https://www.youtube.com/watch?v=CO1QC7BNvig)

</div>

## 💡 TLDR: Turn interactive prompts into long videos—instantly, as you type!

**LongLive: Real-time Interactive Long Video Generation [[Paper](https://arxiv.org/abs/2509.22622)]** <br />
[Shuai Yang](https://andysonys.github.io/), [Wei Huang](https://aaron-weihuang.com/), [Ruihang Chu](https://ruihang-chu.github.io/), [Yicheng Xiao](https://easonxiao-888.github.io/), [Yuyang Zhao](https://yuyangzhao.com/), [Xianbang Wang](https://peppaking8.github.io/), [Muyang Li](https://lmxyy.me/), [Enze Xie](https://xieenze.github.io/), [Yingcong Chen](https://www.yingcong.me/), [Yao Lu](https://scholar.google.com/citations?user=OI7zFmwAAAAJ&hl=en), [Song Han](http://songhan.mit.edu/), [Yukang Chen](https://yukangchen.com/) <br />


## TABLE OF CONTENTS
1. [News](#news)
2. [Highlights](#highlights)
3. [Introduction](#introduction)
4. [How to contribute](#how-to-contribute)
5. [Citation](#citation)
6. [License](#license)
7. [Acknowledgement](#acknowledgement)

## News
- [x] [2026.1.27] **LongLive is accepted by ICLR-2026.** 🎉🎉🎉
- [x] [2026.1.11] Many thanks @qixinhu11 for adapting LongLive's original RoPE into KV-cache relative RoPE. Now LongLive supports generating infinite long videos!
- [x] [2025.12.4] We fix a bug in `global_sink==False` mode. Now our model generate videos in higher quality.
- [x] [2025.11.3] We implement LongLive on linear attention model [SANA-Video](https://nvlabs.github.io/Sana/Video/)! Now SANA-Video can generate 60s interactive videos in real-time.
- [x] [2025.11.1] The license has been changed from CC-BY-NC-SA 4.0 to **Apache 2.0**.
- [x] [2025.10.11] Many thanks to @yondonfu for building an interactive UI based on LongLive. Please check it [here](https://github.com/daydreamlive/scope).
- [x] [2025.10.1] We compare Sora2 (+ GPT-5 prompt engineering) with LongLive-1.3B in the interactive long video generation. See [here](https://x.com/yukangchen_/status/1973405662177529993) for details.
- [x] [2025.9.30] We release [example prompts](https://github.com/NVlabs/LongLive/tree/main/example) to reproduce our demo videos.
- [x] [2025.9.29] We release [Paper](https://arxiv.org/abs/2509.22622), this GitHub repo [LongLive](https://github.com/NVlabs/LongLive) with all training and inference code, the model weight [LongLive-1.3B](https://huggingface.co/Efficient-Large-Model/LongLive-1.3B), and demo page [Website](https://nvlabs.github.io/LongLive).

## Highlights
1. **Long Video Gen**: LongLive supports up to 240s video generation, with visual consistency.
2. **Real-time Inference**: LongLive supports 20.7 FPS generation speed on a single H100 GPU, and 24.8 FPS with FP8 quantization with marginal quality loss.
3. **Efficient Fine-tuning**: LongLive extends a short-clip model to minute-long generation in 32 H100 GPU-days.

## Introduction
<p align="center" style="border-radius: 10px">
  <img src="assets/pipeline.jpg" width="100%" alt="logo"/>
<strong>LongLive accepts sequential user prompts and generates corresponding videos in real time, enabling user-guided long video generation.</strong>
</p>

Please see our [docs](https://nvlabs.github.io/LongLive/docs) for Installation, Training, and Inference.

## Quick Setup

This fork is intended to be used with `uv`.

```bash
uv sync
uv run bash scripts/download_models.sh
uv run torchrun --nproc_per_node=1 --master_port=29500 interactive_inference.py --config_path configs/longlive_interactive_inference.yaml
```

Notes:

- `uv sync` installs the fork's Python dependencies
- `scripts/download_models.sh` downloads the expected weights into `longlive_models/` and `wan_models/`
- optimization-related dependencies such as TensorRT are kept optional
- if you need those extras, use `uv sync --extra optimization`

## Optional: Flash Attention

This fork can run without `flash-attn`, but it also supports installing it separately.

Basic path:

```bash
uv sync --extra flash_attn
uv run bash scripts/install_flash_attn.sh
```

If you want to require a prebuilt wheel and fail otherwise:

```bash
uv run bash scripts/install_flash_attn.sh --wheel-only
```

If you want to try a wheel-friendly torch stack first, you can opt in explicitly:

```bash
TORCH_SPEC='torch==2.8.*' \
TORCHVISION_SPEC='torchvision==0.23.*' \
uv run bash scripts/install_flash_attn.sh --wheel-only
```

Notes:

- the script does not downgrade torch unless you explicitly pass `TORCH_SPEC`
- `--wheel-only` is useful when you want to avoid long source builds
- for `flash-attn` v2.8.3, the available Linux x86_64 wheels include `cp310` through `torch2.8`
- `torch2.9` wheels in `v2.8.3` are `cp312`-only, so they do not match this repo's current Python 3.10 setup
- if `flash-attn` is not installed, the code falls back to SDPA in `wan/modules/attention.py`

## Model Files

The code expects local weights at the following paths:

- `longlive_models/models/longlive_base.pt`
- `longlive_models/models/lora.pt`
- `wan_models/Wan2.1-T2V-1.3B/models_t5_umt5-xxl-enc-bf16.pth`
- `wan_models/Wan2.1-T2V-1.3B/Wan2.1_VAE.pth`

If the Hugging Face repositories require authentication in your environment, run `hf auth login` first.

## How to contribute
- Make sure to have git installed.
- Create your own [fork](https://github.com/NVlabs/LongLive/fork) of the project.
- Clone the repository on your local machine, using git clone and pasting the url of this project.
- Read both the `Requirements` and `Installation and Quick Guide` sections below.
- Commit and push your changes.
- Make a pull request when finished modifying the project.


## Citation
Please consider to cite our paper and this framework, if they are helpful in your research.
```bibtex
@article{yang2025longlive,
      title={LongLive: Real-time Interactive Long Video Generation},
      author={Shuai Yang and Wei Huang and Ruihang Chu and Yicheng Xiao and Yuyang Zhao and Xianbang Wang and Muyang Li and Enze Xie and Yingcong Chen and Yao Lu and Song Hanand Yukang Chen},
      year={2025},
      eprint={2509.22622},
      archivePrefix={arXiv},
      primaryClass={cs.CV}
}
```

## Acknowledgement
- [Self-Forcing](https://github.com/guandeh17/Self-Forcing): the codebase and algorithm we built upon. Thanks for their wonderful work.
- [Wan](https://github.com/Wan-Video/Wan2.1): the base model we built upon. Thanks for their wonderful work.

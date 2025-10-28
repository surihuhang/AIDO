

1. 执行Data Select模块

1）准备工作
部署llama-70B
conda activate evalscope
CUDA_VISIBLE_DEVICES=0,1,2,3 nohup python -m vllm.entrypoints.openai.api_server \
--model /mnt/beegfs/xr/models/llama/Llama-3.3-70B-Instruct \
--served-model-name llama3.1-70B \
--dtype bfloat16 \
--port 9000 \
--tensor-parallel-size 4 \
--gpu-memory-utilization 0.85 \
--max-model-len 8192 > vllm-70B.log 2>&1 &

2) 进行Stage 1
conda activate OpenAI
python Select/Classifing_Scoring.py \
    --input_path ../Dataset/Dolly_data_15k.json \
    --output_dir ../Select/data/stage_1_data/Dolly_classifying_scoring/ \
    --api_base "http://0.0.0.0:9000/v1" \
    --model_name "llama3.1-70B"

3) 进行Stage 2
conda activate IFD
CUDA_VISIBLE_DEVICES=4,5 nohup python Select/Clustering_Ranking.py \
    --json_data_path ./Select/data/stage_1_Classifying_Scoring/Dolly/Data_stage_1.json \
    --model_name_or_path ../models/Meta-Llama-3.1-8B-Instruct \
    --output_dir ../Select/data/stage_2_Clustering_Ranking/Dolly/ \
    --result_dir /mnt/beegfs/xr/liu_zy/Data_OP/AIDO/Result \
    --name Dolly \
    --kmeans_num_clusters 132 \
    --k_ratio 0.8 \
    --max_length 4096 \
    --prompt alpaca \
    --mod pre \
    > Dolly_stage_2.log 2>&1 &



2. 执行Data Revise模块

1) 准备工作：
部署Llama3.1-70B  和  Llama3.1-8B:
conda activate evalscope
CUDA_VISIBLE_DEVICES=0,1 nohup python -m vllm.entrypoints.openai.api_server \
--model /mnt/beegfs/xr/models/llama/Llama-3.1-70B-Instruct \
--served-model-name llama3.1-70B \
--dtype bfloat16 \
--port 9000 \
--tensor-parallel-size 4 \
--gpu-memory-utilization 0.85 \
--max-model-len 8192 > vllm-70B.log 2>&1 &


CUDA_VISIBLE_DEVICES=2 nohup python -m vllm.entrypoints.openai.api_server \
--model /mnt/beegfs/xr/models/llama/Llama-3.1-8B-Instruct \
--served-model-name llama3.1-8B \
--dtype bfloat16 \
--port 8000 \
--tensor-parallel-size 1 \
--gpu-memory-utilization 0.85 \
--max-model-len 8192 > vllm-8B.log 2>&1 &


2） 执行改写启动脚本step_run.sh

bash Revise/Iterative_Revise_Run.sh


最终合并高分和修改后的低分：

python Result/Connect.py \
    --input_path_1 "./Dolly_high.json" \
    --input_path_2 "./Dolly_low_revised.json" \
    --output_path "./Dolly_Final_Data.json"
conda activate OpenAI
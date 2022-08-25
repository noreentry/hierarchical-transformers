export WANDB_PROJECT="hi-transformers"
export PYTHONPATH=.
export CUDA_VISIBLE_DEVICES=4,5,6,7

MODEL_NAME='hi-transformer-p1-grouped'
MODEL_MAX_LENGTH=1024
MAX_SENTENCES=8
TEMPERATURE=0.5
LAYOUT='p1'

python models/hi_transformer/convert_bert_to_htf.py --layout ${LAYOUT} --max_sentences ${MAX_SENTENCES}

python language_modelling/run_pretraining_simclr_stream.py \
    --model_name_or_path data/PLMs/${MODEL_NAME} \
    --dataset_name ./data/wikipedia-dataset \
    --dataset_config_name 20200501.en \
    --do_train \
    --do_eval \
    --output_dir data/PLMs/${MODEL_NAME}-mlm-simclr-50k-V2-${TEMPERATURE} \
    --overwrite_output_dir \
    --logging_steps 500 \
    --evaluation_strategy steps \
    --eval_steps 10000 \
    --save_strategy steps \
    --save_steps 10000 \
    --save_total_limit 5 \
    --max_steps 50000 \
    --learning_rate 1e-4 \
    --per_device_train_batch_size 16 \
    --per_device_eval_batch_size 16 \
    --gradient_accumulation_steps 2 \
    --eval_accumulation_steps 2 \
    --lr_scheduler_type linear \
    --warmup_ratio 0.10 \
    --weight_decay 0.01 \
    --mlm_probability 0.15 \
    --max_seq_length ${MODEL_MAX_LENGTH} \
    --line_by_line \
    --pad_to_max_length \
    --sent_sim 1 \
    --doc_sim 1 \
    --mlm 1 \
    --complementary_masking \
    --temperature ${TEMPERATURE}
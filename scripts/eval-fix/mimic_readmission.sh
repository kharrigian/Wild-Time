#CORAL
python main.py --dataset=mimic --method=coral --offline --prediction_type=readmission --coral_lambda=1.0 --num_groups=3 --group_size=2 --mini_batch_size=128 --train_update_iter=3000 --lr=5e-4 --num_workers=0 --random_seed=1 --split_time=2013 --data_dir=./Data --log_dir=./checkpoints/

#GroupDRO
python main.py --dataset=mimic --method=groupdro --offline --prediction_type=readmission --num_groups=3 --group_size=2 --mini_batch_size=128 --train_update_iter=3000 --lr=5e-4 --num_workers=0 --random_seed=1 --split_time=2013 --data_dir=./Data --log_dir=./checkpoints/

#IRM
python main.py --dataset=mimic --method=irm --offline --prediction_type=readmission --irm_lambda=1.0 --irm_penalty_anneal_iters=0 --num_groups=3 --group_size=2 --mini_batch_size=128 --train_update_iter=3000 --lr=5e-4 --num_workers=0 --random_seed=1 --split_time=2013 --data_dir=./Data --log_dir=./checkpoints/

#ERM
python main.py --dataset=mimic --method=erm --offline --prediction_type=readmission --mini_batch_size=128 --train_update_iter=3000 --lr=5e-4 --num_workers=0 --random_seed=1 --split_time=2013 --data_dir=./Data --log_dir=./checkpoints/

#Task Difficulty
python main.py --dataset=mimic --method=erm --offline --prediction_type=readmission --mini_batch_size=128 --train_update_iter=3000 --lr=5e-4 --num_workers=0 --random_seed=1 --split_time=2013 --data_dir=./Data --log_dir=./checkpoints/ --difficulty

#LISA
python main.py --dataset=mimic --method=erm --offline --lisa --mix_alpha=2.0 --prediction_type=readmission --mini_batch_size=128 --train_update_iter=3000 --lr=5e-4 --num_workers=0 --random_seed=1 --split_time=2013 --data_dir=./Data --log_dir=./checkpoints/

#Mixup
python main.py --dataset=mimic --method=erm --offline --mixup --mix_alpha=2.0 --prediction_type=readmission --mini_batch_size=128 --train_update_iter=3000 --lr=5e-4 --num_workers=0 --random_seed=1 --split_time=2013 --data_dir=./Data --log_dir=./checkpoints/

#A-GEM
python main.py --dataset=mimic --prediction_type=readmission --method=agem --buffer_size=1000 --mini_batch_size=128 --train_update_iter=3000 --lr=1e-1 --offline --num_workers=0 --split_time=2013 --random_seed=1 --data_dir=./Data --log_dir=./checkpoints/

#EWC
python main.py --dataset=mimic --prediction_type=readmission --method=ewc --ewc_lambda=0.5 --online --mini_batch_size=128 --train_update_iter=3000 --lr=1e-1 --offline --num_workers=0 --split_time=2013 --random_seed=1 --data_dir=./Data --log_dir=./checkpoints/

#Fine-tuning
python main.py --dataset=mimic --prediction_type=readmission --method=ft --mini_batch_size=128 --train_update_iter=3000 --lr=1e-1 --offline --num_workers=0 --split_time=2013 --random_seed=1 --data_dir=./Data --log_dir=./checkpoints/

#SI
python main.py --dataset=mimic --prediction_type=readmission --method=si --si_c=0.1 --epsilon=0.001 --mini_batch_size=128 --train_update_iter=3000 --lr=1e-1 --offline --num_workers=0 --split_time=2013 --random_seed=1 --data_dir=./Data --log_dir=./checkpoints/
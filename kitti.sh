OUTPUT_PATH="/home/output/KITTI"
DATASET_PATH="/home/dataset/KITTI"

str_pad() {

  local pad_length="$1" pad_string="$2" pad_type="$3"
  local pad length llength offset rlength

  pad="$(eval "printf '%0.${#pad_string}s' '${pad_string}'{1..$pad_length}")"
  pad="${pad:0:$pad_length}"

  if [[ "$pad_type" == "left" ]]; then

    while read line; do
      line="${line:0:$pad_length}"
      length="$(( pad_length - ${#line} ))"
      echo -n "${pad:0:$length}$line"
    done

  elif [[ "$pad_type" == "both" ]]; then

    while read line; do
      line="${line:0:$pad_length}"
      length="$(( pad_length - ${#line} ))"
      llength="$(( length / 2 ))"
      offset="$(( llength + ${#line} ))"
      rlength="$(( llength + (length % 2) ))"
      echo -n "${pad:0:$llength}$line${pad:$offset:$rlength}"
    done

  else

    while read line; do
      line="${line:0:$pad_length}"
      length="$(( pad_length - ${#line} ))"
      echo -n "$line${pad:${#line}:$length}"
    done

  fi
}

run_()
{
    local dataset=$1
    local config=$2
    local result_txt=$3
    local keyframe_th=$4
    local knn_maxd=$5
    local overlapped_th=$6
    local max_correspondence_distance=$7
    local trackable_opacity_th=$8
    local overlapped_th2=$9
    local downsample_rate=${10}

    # Generate a timestamp
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    
    echo "run $dataset"
    python -W ignore gs_icp_slam.py --dataset_path $DATASET_PATH/$dataset\
                                    --config $config\
                                    --output_path $OUTPUT_PATH/$dataset/GS_ICP_SLAM/$timestamp\
                                    --keyframe_th $keyframe_th\
                                    --knn_maxd $knn_maxd\
                                    --overlapped_th $overlapped_th\
                                    --max_correspondence_distance $max_correspondence_distance\
                                    --trackable_opacity_th $trackable_opacity_th\
                                    --overlapped_th2 $overlapped_th2\
                                    --downsample_rate $downsample_rate\
                                    --save_results
    wait
}

run_kitti()
{
    local result_txt=$1
    local keyframe_th=$2
    local knn_maxd=$3
    local overlapped_th=$4
    local max_correspondence_distance=$5
    local trackable_opacity_th=$6
    local overlapped_th2=$7
    local downsample_rate=$8

    run_ "2011_09_26_drive_0093" "configs/KITTI/2011_09_26_drive_0093.txt" $result_txt $keyframe_th $knn_maxd $overlapped_th $max_correspondence_distance $trackable_opacity_th $overlapped_th2 $downsample_rate    
}

# txt_file="re_init_ablation/default_3DGS.txt"
txt_file="plane_regularization.txt"
str_pad 20 " " left <<< "FPS" > $txt_file
str_pad 15 " " left <<< "RMSE" >> $txt_file
str_pad 15 " " left <<< "train iter" >> $txt_file
str_pad 15 " " left <<< "kframes" >> $txt_file
str_pad 15 " " left <<< "gaussians_num" >> $txt_file
# str_pad 32 " " left <<< "Depth L1" >> $txt_file
str_pad 30 " " left <<< "PSNR" >> $txt_file
str_pad 15 " " left <<< "SSIM" >> $txt_file
str_pad 15 " " left <<< "LPIPS" >> $txt_file
echo "" >> $txt_file

overlapped_th=1e-4
max_correspondence_distance=0.05
knn_maxd=100.0

trackable_opacity_th=0.05
overlapped_th2=1e-5
downsample_rate=5
keyframe_th=0.7

run_kitti $txt_file $keyframe_th $knn_maxd $overlapped_th $max_correspondence_distance \
$trackable_opacity_th $overlapped_th2 $downsample_rate
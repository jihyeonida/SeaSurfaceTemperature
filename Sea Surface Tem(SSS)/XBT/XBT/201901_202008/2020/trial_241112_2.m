% 데이터 크기 설정
lat_dim = 10;     % 위도 개수
lon_dim = 8;      % 경도 개수
days_dim = 30;    % 날짜 개수

% 빈 데이터 행렬 (위도 x 경도 x 날짜) 생성 - NaN으로 초기화
data = NaN(lat_dim, lon_dim, days_dim);

% 각 날짜별로 3-4개의 랜덤 위치에만 관측값을 할당
for day = 1:days_dim
    num_obs = randi([3, 4]);  % 3 또는 4개의 관측값 선택
    rand_indices = randperm(lat_dim * lon_dim, num_obs);  % 무작위 위치 선택
    
    for idx = 1:num_obs
        [lat_idx, lon_idx] = ind2sub([lat_dim, lon_dim], rand_indices(idx));
        data(lat_idx, lon_idx, day) = rand();  % 임의의 관측값 할당
    end
end

% 날짜별로 비어 있지 않은 관측값만 모아 행렬 구성
non_nan_data = cell(1, days_dim);  % 날짜별 관측값 저장할 셀 배열

for day = 1:days_dim
    % 현재 날짜에서 NaN이 아닌 관측값 추출
    day_data = data(:, :, day);
    valid_data = day_data(~isnan(day_data));  % NaN이 아닌 값만 추출
    
    % 비어 있지 않은 데이터만 벡터로 저장
    non_nan_data{day} = valid_data;
end

% 모든 날짜의 비어 있지 않은 데이터를 모은 행렬 생성
% 최대 벡터 길이를 확인하여 빈 자리를 NaN으로 채울 수 있도록 배열화
max_length = max(cellfun(@length, non_nan_data));  % 각 열 벡터의 최대 길이
result_matrix = NaN(max_length, days_dim);  % NaN으로 초기화된 결과 행렬

% non_nan_data의 각 벡터를 result_matrix의 열로 할당
for day = 1:days_dim
    vec_length = length(non_nan_data{day});
    result_matrix(1:vec_length, day) = non_nan_data{day};  % 각 벡터를 열에 맞게 배치
end

% 결과 출력
disp('날짜별 비어 있지 않은 관측값으로 구성된 행렬:');
disp(result_matrix);

%%
% NaN을 포함하는 데이터로부터 공분산 및 SVD 계산

% 가정: result_matrix가 날짜별로 비어있지 않은 관측값을 포함한 행렬로 이미 생성됨
% 결과 행렬 크기 확인
[m, n] = size(result_matrix);

% 1. 각 열의 NaN을 제거한 상태에서 평균 계산
column_means = nanmean(result_matrix, 1);  % 각 열의 NaN이 아닌 값에 대한 평균

% 2. NaN 값을 각 열의 평균값으로 대체하여 행렬 완성
filled_matrix = result_matrix;
for i = 1:n
    nan_indices = isnan(filled_matrix(:, i));
    filled_matrix(nan_indices, i) = column_means(i);  % NaN을 열 평균으로 대체
end

% 3. 공분산 행렬 계산 (NaN이 대체된 행렬로)
cov_matrix = cov(filled_matrix, 'omitrows');  % 열 간 공분산

% 4. SVD 계산
[U, S, V] = svd(filled_matrix, 'econ');  % NaN이 대체된 행렬로 SVD 수행

% 결과 출력
disp('공분산 행렬:');
disp(cov_matrix);
disp('SVD 결과 - U 행렬:');
disp(U);
disp('SVD 결과 - S 행렬 (특잇값):');
disp(S);
disp('SVD 결과 - V 행렬:');
disp(V);
% 3차원 데이터 크기 설정
time_steps = 62;     % 시간 차원
locations = 45;      % 위치 차원
max_observations = 72; % 최대 관측치 수

% 임의 데이터 생성 (데이터가 NaN 값 포함한다고 가정)
data = NaN(time_steps, locations, max_observations);

% 각 시간과 위치에 대해 12개의 임의 관측값을 할당 (NaN을 포함하지 않는 값들)
for t = 1:time_steps
    for loc = 1:locations
        num_obs = randi([10, 12]);  % 10~12개의 관측값 생성
        data(t, loc, 1:num_obs) = rand(1, num_obs);  % 일부 관측값 할당
    end
end
%%
% 시간-위치 쌍에서 관측 데이터의 평균값을 사용하지 않고 
% 12개의 데이터의 정보를 반영하는 방법으로, 예를 들어 공분산 계산을 위한
% 값들을 1차원 벡터로 변환하여 SVD 수행 가능

% 1. 시간-위치별 관측 데이터 수집 및 전처리
flattened_data = NaN(time_steps * locations, max_observations);
for t = 1:time_steps
    for loc = 1:locations
        % 현재 시간-위치에 대한 관측 데이터 추출
        observations = squeeze(data(t, loc, :));
        valid_data = observations(~isnan(observations));  % NaN 제거

        % 시간-위치 쌍에 대한 관측치를 평탄화 행렬에 할당
        idx = (t - 1) * locations + loc;  % 행 인덱스 계산
        flattened_data(idx, 1:numel(valid_data)) = valid_data';
    end
end
%%
% 2. 공분산 행렬 계산
cov_matrix = cov(flattened_data, 'omitrows');

% 3. SVD 계산
[U, S, V] = svd(flattened_data, 'econ');

% 결과 출력
disp('공분산 행렬:');
disp(cov_matrix);
disp('SVD 결과 - U 행렬:');
disp(U);
disp('SVD 결과 - S 행렬 (특잇값):');
disp(S);
disp('SVD 결과 - V 행렬:');
disp(V);

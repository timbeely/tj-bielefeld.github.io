import pandas
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression

''' 
The following is the starting code for path2 for data reading to make your first step easier.
'dataset_2' is the clean data for path2.
'''
dataset_2 = pandas.read_csv('NYC_Bicycle_Counts_2016.csv')
dataset_2['Brooklyn Bridge']      = pandas.to_numeric(dataset_2['Brooklyn Bridge'].replace(',','', regex=True))
dataset_2['Manhattan Bridge']     = pandas.to_numeric(dataset_2['Manhattan Bridge'].replace(',','', regex=True))
dataset_2['Queensboro Bridge']    = pandas.to_numeric(dataset_2['Queensboro Bridge'].replace(',','', regex=True))
dataset_2['Williamsburg Bridge']  = pandas.to_numeric(dataset_2['Williamsburg Bridge'].replace(',','', regex=True))
print(dataset_2.to_string()) #This line will print out your data


# Intialization
bridges = ['Brooklyn Bridge', 'Manhattan Bridge', 'Queensboro Bridge', 'Williamsburg Bridge']

dataset_2['Total Traffic'] = dataset_2[bridges].sum(axis=1)
y = dataset_2['Total Traffic']

# Problem 1: Sensor Optimization (Regression)
def problem_1():
    # Part 1: Linear Regression Model combos of 3 bridges
    print("\n=====================================")
    print("PROBLEM 1 — 3-BRIDGE REGRESSION COMBINATIONS")
    print("=====================================")

    combos = [
        ['Brooklyn Bridge','Manhattan Bridge','Williamsburg Bridge'],
        ['Brooklyn Bridge','Manhattan Bridge','Queensboro Bridge'],
        ['Brooklyn Bridge','Williamsburg Bridge','Queensboro Bridge'],
        ['Manhattan Bridge','Williamsburg Bridge','Queensboro Bridge']
    ]

    combo_results = []

    # Iterate through each combination
    for combo in combos:
        # Make model
        model = LinearRegression()
        model.fit(dataset_2[combo], y)

        # R² Score
        r2_score = model.score(dataset_2[combo], y)
        combo_results.append((combo, r2_score))

        #Print results
        print(f"Combination: {combo} => R² Score: {round(r2_score, 5)}")

    # Identify best combination
    best_combo, best_r2 = max(combo_results, key=lambda x: x[1])
    print(f"\nBest 3-bridge combination: {best_combo} with R² Score: {round(best_r2, 5)}")
    # Print final conclusions
    print("\n================================")
    print("FINAL CONCLUSIONS — PROBLEM 1")
    print("================================")


    print("1. Testing all three-bridge combinations showed that")
    print("   the best sensor configuration is:")

    for b in best_combo:
        print("  ", b)

    print(f"\n2. Best three-bridge model R²: {best_r2:.5f}\n")


# Problem 2: Weather Forecast Analysis
def problem_2():
    print("\n==============================")
    print("PROBLEM 2 — WEATHER REGRESSION")
    print("==============================\n")

    # Load weather data
    X_weather = dataset_2[['High Temp', 'Low Temp', 'Precipitation']]
    y_weather = dataset_2['Total Traffic']

    # Create and fit model
    model_weather = LinearRegression()
    model_weather.fit(X_weather, y_weather)

    # R² Score
    r2_weather = model_weather.score(X_weather, y_weather)
    print(f"Weather Model R² Score: {round(r2_weather, 5)}\n")

    # Coefficients
    coeffs = model_weather.coef_
    print("Weather Model Coefficients:")
    print(f" - High Temp Coefficient: {round(coeffs[0], 5)}")
    print(f" - Low Temp Coefficient: {round(coeffs[1], 5)}")
    print(f" - Precipitation Coefficient: {round(coeffs[2], 5)}\n")
    
    # Final conclusions
    print("================================")
    print("FINAL CONCLUSIONS — PROBLEM 2")
    print("================================")
       
    if r2_weather > 0.60:
        conclusion = "strong predictor"
    elif r2_weather > 0.30:
        conclusion = "moderate predictor"
    else:
        conclusion = "weak predictor"

    print(f"Weather variables are a {conclusion} of daily bicycle traffic.")
    print("Temperature has a positive impact on ridership.")
    print("Precipitation has a negative impact on ridership.")

    print("\nCorrelation Matrix:")
    print(dataset_2[['High Temp','Low Temp','Precipitation','Total Traffic']].corr())   


# Problem 3: Weekly Traffic Trends
def problem_3():
    
    print("==============================")
    print("PROBLEM 3 — WEEKLY TRAFFIC TRENDS")
    print("==============================\n")

    # Group by Day of Week
    daily_means = dataset_2.groupby('Day')['Total Traffic'].mean()
    print("Average Daily Traffic by Day of Week:\n")
    for day in daily_means.index:
        print(f" - {day}: {round(daily_means[day], 2)}")
    
    # Rank days by traffic
    print("\nRanking of days (Highest to lowest average traffic)")
    ranked_days = daily_means.sort_values(ascending=False)

    rank = 1
    for day, traffic in ranked_days.items():
        print(f" {rank}. {day}: {round(traffic, 2)}")
        rank += 1
    
    # Weekend vs Weekday Analysis
    weekend_avg = daily_means[['Saturday', 'Sunday']].mean()
    weekday_avg = daily_means[['Monday', 'Tuesday', 'Wednesday', 'Thursday','Friday']].mean()
    print("\nWeekend vs Weekday Average Traffic:")
    print(f" - Weekend Average Traffic: {round(weekend_avg, 2)}")
    print(f" - Weekday Average Traffic: {round(weekday_avg, 2)}")
    
    if weekend_avg > weekday_avg:
        print("\nConclusion: Weekend days have higher average traffic than weekdays.")
    else:
        print("\nConclusion: Weekdays have higher average traffic than weekends.")

    #Predict day of week for a given traffic count
    user_input = input("\nEnter today's observed TOTAL bicycle traffic count: ")
    try:
        today_traffic = float(user_input)

        smallest_diff = float("inf")
        predicted_day = ""

        for day in daily_means.index:
            diff = abs(today_traffic - daily_means[day])

            if diff < smallest_diff:
                smallest_diff = diff
                predicted_day = day

        print(f"\nPredicted Day of the Week: {predicted_day}")

    except:
        print("Invalid input. Please try again and enter a valid number.")

    # Create a bar chart of average traffic by day
    ordered_days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    ordered_means = [daily_means[d] for d in ordered_days]

    plt.figure(figsize=(10,6))
    plt.bar(ordered_days, ordered_means)
    plt.xlabel("Day of Week")
    plt.ylabel("Average Total Bicycle Traffic")
    plt.title("Average Daily Bicycle Traffic in NYC")
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.grid(axis='y', linestyle='--', linewidth=0.7, alpha=0.6)
    plt.show()


# User Interface
print("\n==============================")
print("NYC BIKE TRAFFIC MINI PROJECT")
print("==============================")
print("Select which problem to run:")
print("1 - Sensor Optimization")
print("2 - Weather Forecast Analysis")
print("3 - Weekly Traffic Trends")
print("==============================")

choice = input("Enter problem number (1, 2, or 3): ")

if choice == "1":
    print("\nRunning Problem 1...")
    problem_1()

elif choice == "2":
    print("\nRunning Problem 2...")
    problem_2()

elif choice == "3":
    print("\nRunning Problem 3...")
    problem_3()

else:
    print("\nInvalid selection. Please restart and choose 1, 2, or 3.")
